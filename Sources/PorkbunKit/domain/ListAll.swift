//
//  GetNS.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.Domain {
    /// Get all domain names in account. Domains are returned in chunks of 1000.
    public struct ListAll : Porkbun.AuthenticationRequired {
        public let secretapikey:String
        public let apikey:String

        /// An index to start at when retrieving the domains, defaults to 0. To get all domains increment by 1000 until you receive an empty array.
        public let start:String?

        /// If set to "yes" we will return label information for the domains if it exists.
        public let includeLabels:String?

        public init(apiKey: String, secretAPIKey: String, start: Int? = nil, includeLabels: Bool = false) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
            self.start = start?.description
            self.includeLabels = includeLabels ? "yes" : nil
        }

        public var endpointSlug: String { "domain/listAll" }
    }
}

// MARK: Response
extension Porkbun.Domain.ListAll {
    /// Get all domain names in account. Domains are returned in chunks of 1000.
    public struct Response : Porkbun.Response {
        public let status:String
        public let message:String?
        public let domains:[Porkbun.Domain]?
    }
}