//
//  UpdateNS.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.Domain {
    /// Update the name servers for your domain.
    public struct UpdateNS : Porkbun.AuthenticationRequired {
        public let secretapikey:String
        public let apikey:String

        /// Your domain.
        public let domain:String

        /// Set of name servers that you would like to update your domain with.
        public let ns:[String]

        public init(apiKey: String, secretAPIKey: String, domain: String, nameServers: [String]) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
            self.domain = domain
            self.ns = nameServers
        }

        public var endpointSlug : String { "domain/updateNs/" + domain }
    }
}

// MARK: Response
extension Porkbun.Domain.UpdateNS {
    public struct Response : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?
    }
}