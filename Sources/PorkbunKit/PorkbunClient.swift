//
//  PorkbunClient.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

import AsyncHTTPClient
import NIOCore
import NIOFoundationCompat

#if canImport(FoundationEssentials)
import FoundationEssentials
#elseif canImport(Foundation)
import Foundation
#endif

// MARK: PorkbunClient
public struct PorkbunClient : Encodable {
    public var apikey:String
    public var secretapikey:String
    public var jsonEncoder:JSONEncoder

    /// Subdomain of the Porkbun API you want to contact.
    /// 
    /// Default is `api`.
    /// 
    /// ## IPv4 Only Hostname
    /// Some folks prefer to force IPv4, especially when using the ping command to get back an IP address for dynamic DNS clients.
    /// The dedicated IPv4 hostname is `api-ipv4.porkbun.com`, so you would use `api-ipv4`.
    public var apiSubdomain:String

    /// Version of the Porkbun API you want to contact.
    /// 
    /// Default is `v3`.
    public var apiVersion:String

    public init(
        apiKey: String,
        secretAPIKey: String,
        jsonEncoder: JSONEncoder = JSONEncoder(),
        apiSubdomain: String = "api",
        apiVersion: String = "v3"
    ) {
        self.apikey = apiKey
        self.secretapikey = secretAPIKey
        self.jsonEncoder = jsonEncoder
        self.apiSubdomain = apiSubdomain
        self.apiVersion = apiVersion
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(apikey, forKey: .apikey)
        try container.encode(secretapikey, forKey: .secretapikey)
    }

    func authenticatedResponse<T : Decodable>(slug: String) async throws -> T? {
        let buffer = try ByteBuffer(bytes: jsonEncoder.encode(self))

        return try await authenticatedResponse(
            slug: slug,
            buffer: buffer
        )
    }
    func authenticatedResponse<AR : Porkbun.AuthenticationRequired, T : Decodable>(
        slug: String,
        request: AR
    ) async throws -> T? {
        return try await authenticatedResponse(
            slug: slug,
            body: .bytes(ByteBuffer(data: jsonEncoder.encode(request)))
        )
    }
    func authenticatedResponse<T : Decodable>(
        slug: String,
        buffer: ByteBuffer
    ) async throws -> T? {
        return try await authenticatedResponse(
            slug: slug,
            body: .bytes(buffer)
        )
    }
    func authenticatedResponse<T : Decodable>(
        slug: String,
        body: HTTPClientRequest.Body
    ) async throws -> T? {
        var request = HTTPClientRequest(url: "https://\(apiSubdomain).porkbun.com/api/json/\(apiVersion)/" + slug)
        request.method = .POST
        request.body = body
        let result = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        let r = try await result.body.collect(upTo: Int.max)
        return try r.getJSONDecodable(T.self, at: r.readerIndex, length: r.readableBytes)
    }
}

// MARK: CodingKeys
extension PorkbunClient {
    public enum CodingKeys : CodingKey {
        case apikey
        case secretapikey
    }
}

// MARK: Ping
extension PorkbunClient {
    public func ping() async throws -> Porkbun.Response.Ping? {
        return try await authenticatedResponse(slug: "ping")
    }
}

// MARK: Name Servers
extension PorkbunClient {
    /// - Returns: The authoritative name servers listed at the registry for the domain.
    public func nameServers(forDomain domain: String) async throws -> Porkbun.Response.GetNS? {
        return try await authenticatedResponse(slug: "domain/getNs/" + domain)
    }
}

// MARK: List All
extension PorkbunClient {
    /// Get all domain names for the account associated with the API keys. Domains are returned in chunks of 1000.
    /// 
    /// - Parameters:
    ///   - start: Index to start at when retrieving the domains, defaults to 0. To get all domains increment by 1000 until you receive an empty array.
    ///   - includeLabels: If `true` we will return label information for the domains if it exists.
    public func listAll(
        start: Int? = nil,
        includeLabels: Bool = false
    ) async throws -> Porkbun.Response.ListAll? {
        let r = Porkbun.Domain.ListAll(apiKey: apikey, secretAPIKey: secretapikey, start: start, includeLabels: includeLabels)
        return try await authenticatedResponse(
            slug: "domain/listAll",
            request: r
        )
    }
}

// MARK: Create Record
extension PorkbunClient {
    /// Create a DNS record.
    /// 
    /// - Parameters:
    ///   - forDomain: Domain you want to create the DNS record under.
    ///   - name: Subdomain for the record being created, not including the domain itself. Leave blank to create a record on the root domain. Use `*` to create a wildcard record.
    ///   - type: Type of record being created.
    ///   - content: Answer content for the record. Please see the DNS management popup from the domain management console for proper formatting of each record type.
    ///   - ttl: Time to live in seconds for the record. The minimum and the default is 600 seconds.
    ///   - prio: Priority of the record for those that support it.
    public func createRecord(
        forDomain domain: String,
        name: String? = nil,
        type: Porkbun.DNS.RecordType,
        content: String,
        ttl: Int? = nil,
        prio: Int? = nil
    ) async throws -> Porkbun.Response.DNSCreateRecord? {
        let r = Porkbun.DNS.CreateRecord(apikey: apikey, secretapikey: secretapikey, name: name, type: type, content: content, ttl: ttl?.description, prio: prio?.description)
        return try await authenticatedResponse(
            slug: "dns/create/" + domain,
            request: r
        )
    }
}

// MARK: Edit Record
extension PorkbunClient {
    /// Edit a DNS record.
    /// 
    /// - Parameters:
    ///   - forDomain: Domain you want to edit the DNS record under.
    ///   - id: Record ID you want to edit.
    ///   - name: Subdomain for the record being created, not including the domain itself. Leave blank to create a record on the root domain. Use `*` to create a wildcard record.
    ///   - type: Type of record being created.
    ///   - content: Answer content for the record. Please see the DNS management popup from the domain management console for proper formatting of each record type.
    ///   - ttl: Time to live in seconds for the record. The minimum and the default is 600 seconds.
    ///   - prio: Priority of the record for those that support it.
    public func editRecord(
        forDomain domain: String,
        id: Int,
        name: String? = nil,
        type: Porkbun.DNS.RecordType,
        content: String,
        ttl: Int? = nil,
        prio: String? = nil
    ) async throws -> Porkbun.Response.DNSEditRecord? {
        let r = Porkbun.DNS.EditRecord(apikey: apikey, secretapikey: secretapikey, name: name, type: type, content: content, ttl: ttl?.description, prio: prio?.description)
        return try await authenticatedResponse(
            slug: "dns/edit/" + domain + "/\(id)",
            request: r
        )
    }
}

// MARK: Delete Record
extension PorkbunClient {
    /// Delete a specific DNS record.
    /// 
    /// - Parameters:
    ///   - domain: Domain you want to delete the DNS record under.
    ///   - id: Record ID you want to delete.
    public func deleteRecord(
        forDomain domain: String,
        id: Int
    ) async throws -> Porkbun.Response.DNSDeleteRecord? {
        let r = Porkbun.DNS.DeleteRecord(apikey: apikey, secretapikey: secretapikey, domain: domain, recordID: id)
        return try await authenticatedResponse(
            slug: "dns/delete/" + domain + "/\(id)",
            request: r
        )
    }
}

// MARK: Check Domain
extension PorkbunClient {
    /// Check a domain's availability.
    /// Please note that domain checks are rate limited and you will be notified of your limit when you cross it.
    /// 
    /// - Parameters:
    ///   - domain: Domain you want to check.
    public func checkDomain(
        domain: String
    ) async throws -> Porkbun.Response.CheckDomain? {
        let r = Porkbun.Domain.Check(apikey: apikey, secretapikey: secretapikey, domain: domain)
        return try await authenticatedResponse(
            slug: "domain/checkDomain/" + domain,
            request: r
        )
    }
}