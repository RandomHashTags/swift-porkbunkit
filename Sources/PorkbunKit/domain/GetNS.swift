//
//  GetNS.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.Domain {
    /// Get the authoritative name servers listed at the registry for your domain.
    public struct GetNS : Porkbun.AuthenticationRequired {
        public let secretapikey:String
        public let apikey:String

        /// Your domain.
        public let domain:String

        public init(apiKey: String, secretAPIKey: String, domain: String) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
            self.domain = domain
        }

        public var endpointSlug: String { "domain/getNs/" + domain }
    }
}

// MARK: Response
extension Porkbun.Domain.GetNS {
    public struct Response : Porkbun.Response {
        public let status:String
        public let message:String?

        /// An array of name server host names.
        public let ns:[String]?
    }
}