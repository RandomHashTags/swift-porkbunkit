//
//  Check.swift
//
//
//  Created by Evan Anderson on 3/25/25.
//

extension Porkbun.Domain {
    struct Check : Porkbun.AuthenticationRequired {
        let apikey:String
        let secretapikey:String

        let domain:String
    }
}

// MARK: Response
extension Porkbun.Response {
    public struct CheckDomain : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?

        public let response:Response
        public let limits:Limits
    }
}

extension Porkbun.Response.CheckDomain {
    public struct Response : Codable {
        public let avail:String
        public let type:String
        public let price:String
        public let firstYearPromo:String
        public let regularPrice:String
        public let premium:String
        public let additional:Additional
    }
}
extension Porkbun.Response.CheckDomain.Response {
    public struct Additional : Codable {
        public let renewal:FinancialAction
        public let transfer:FinancialAction
    }
}
extension Porkbun.Response.CheckDomain.Response.Additional {
    public struct FinancialAction : Codable {
        public let type:String
        public let price:String
        public let regularPrice:String
    }
}

// MARK: Limits
extension Porkbun.Response.CheckDomain {
    public struct Limits : Codable {
        public let ttl:Int
        public let limit:Int
        public let used:Int
        public let naturalLanguage:String

        public enum CodingKeys : String, CodingKey {
            case ttl = "TTL"
            case limit
            case used
            case naturalLanguage
        }
    }
}