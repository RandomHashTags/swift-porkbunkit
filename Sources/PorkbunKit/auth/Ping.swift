//
//  Authentication.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun {
    public struct Ping : AuthenticationRequired {
        public let secretapikey:String
        public let apikey:String

        public init(apiKey: String, secretAPIKey: String) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
        }

        public var endpointSlug : String { "ping" }
    }
}


// MARK: Response
extension Porkbun.Ping {
    public struct Response : Porkbun.Response {
        public let status:String
        public let message:String?
        public let yourIp:String?
    }
}