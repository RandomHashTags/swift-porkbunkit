//
//  RetrieveRecords.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    /// Create a DNS record.
    public struct RetrieveRecords : Porkbun.AuthenticationRequired {
        public let secretapikey:String
        public let apikey:String

        /// Your domain.
        public let domain:String

        public let recordID:Int?
        
        public init(
            apiKey: String,
            secretAPIKey: String,
            domain: String,
            recordID: Int? = nil
        ) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
            self.domain = domain
            self.recordID = recordID
        }

        public var endpointSlug : String {
            let record:String
            if let recordID:Int = recordID {
                record = "/\(recordID)"
            } else {
                record = ""
            }
            return "dns/retrieve/" + domain + record
        }
    }
}

// MARK: Response
extension Porkbun.DNS.RetrieveRecords {
    public struct Response : Porkbun.Response {
        public let status:String
        public let message:String?
        public let records:[Porkbun.DNS.Record]?
    }
}