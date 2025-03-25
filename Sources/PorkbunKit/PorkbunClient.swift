//
//  PorkbunClient.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

import AsyncHTTPClient
import Foundation
import NIOCore
import NIOFoundationCompat

// MARK: PorkbunClient
public struct PorkbunClient : Encodable {
    public var apikey:String
    public var secretapikey:String
    public var jsonEncoder:JSONEncoder

    public init(
        apiKey: String,
        secretAPIKey: String,
        jsonEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.apikey = apiKey
        self.secretapikey = secretAPIKey
        self.jsonEncoder = jsonEncoder
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(apikey, forKey: .apikey)
        try container.encode(secretapikey, forKey: .secretapikey)
    }

    func authenticatedResponse<T : Decodable>(forSlug slug: String) async throws -> T? {
        let buffer = try ByteBuffer(bytes: jsonEncoder.encode(self))
        return try await authenticatedResponse(forSlug: slug, buffer: buffer)
    }
    func authenticatedResponse<T : Decodable>(forSlug slug: String, buffer: ByteBuffer) async throws -> T? {
        return try await authenticatedResponse(forSlug: slug, body: .bytes(buffer))
    }
    func authenticatedResponse<T : Decodable>(forSlug slug: String, body: HTTPClientRequest.Body) async throws -> T? {
        var request = HTTPClientRequest(url: "https://api.porkbun.com/api/json/v3/" + slug)
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
        return try await authenticatedResponse(forSlug: "ping")
    }
}

// MARK: GetNS
extension PorkbunClient {
    /// - Returns: The authoritative name servers listed at the registry for the domain.
    public func nameServers(forDomain domain: String) async throws -> Porkbun.Response.GetNS? {
        return try await authenticatedResponse(forSlug: "domain/getNs/" + domain)
    }
}

// MARK: ListAll
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
        let buffer = try ByteBuffer(data: jsonEncoder.encode(Porkbun.Domain.ListAll(apiKey: apikey, secretAPIKey: secretapikey, start: start, includeLabels: includeLabels)))
        return try await authenticatedResponse(forSlug: "domain/listAll", body: .bytes(buffer))
    }
}

// MARK: CreateRecord
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
        let buffer = try ByteBuffer(data: jsonEncoder.encode(Porkbun.DNS.CreateRecord(apikey: apikey, secretapikey: secretapikey, name: name, type: type, content: content, ttl: ttl?.description, prio: prio?.description)))
        return try await authenticatedResponse(forSlug: "dns/create/" + domain, body: .bytes(buffer))
    }
}

// MARK: EditRecord
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
        let buffer = try ByteBuffer(data: jsonEncoder.encode(Porkbun.DNS.EditRecord(apikey: apikey, secretapikey: secretapikey, name: name, type: type, content: content, ttl: ttl?.description, prio: prio?.description)))
        return try await authenticatedResponse(forSlug: "dns/edit/" + domain + "/\(id)", buffer: buffer)
    }
}

// MARK: DeleteRecord
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
        let buffer = try ByteBuffer(data: jsonEncoder.encode(Porkbun.DNS.DeleteRecord(apikey: apikey, secretapikey: secretapikey, domain: domain, recordID: id)))
        return try await authenticatedResponse(forSlug: "dns/delete/" + domain + "/\(id)", buffer: buffer)
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
        let buffer = try ByteBuffer(data: jsonEncoder.encode(Porkbun.Domain.Check(apikey: apikey, secretapikey: secretapikey, domain: domain)))
        return try await authenticatedResponse(forSlug: "domain/checkDomain/" + domain, buffer: buffer)
    }
}