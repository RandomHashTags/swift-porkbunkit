//
//  GetNS.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.Domain {
    struct ListAll : Porkbun.AuthenticationRequired {
        let secretapikey:String
        let apikey:String
        let start:String?
        let includeLabels:String?

        init(apiKey: String, secretAPIKey: String, start: Int? = nil, includeLabels: Bool = false) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
            self.start = start?.description
            self.includeLabels = includeLabels ? "yes" : nil
        }
    }
}

// MARK: Response
extension Porkbun.Response {
    /// Get all domain names in account. Domains are returned in chunks of 1000.
    public struct ListAll : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?
        public let domains:[Porkbun.Domain]?
    }
}