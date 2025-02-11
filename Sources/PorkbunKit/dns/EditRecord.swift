//
//  EditRecord.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    /// Edit a DNS record.
    public struct EditRecord : Porkbun.AuthenticationRequired {
        public let secretapikey:String
        public let apikey:String

        /// Your domain.
        public let domain:String

        public let recordID:Int

        /// The subdomain for the record being created, not including the domain itself. Leave blank to create a record on the root domain. Use `*` to create a wildcard record.
        public let name:String?

        /// The type of record being created.
        public let type:RecordType

        /// The answer content for the record. Please see the DNS management popup from the domain management console for proper formatting of each record type.
        public let content:String

        /// The time to live in seconds for the record. The minimum and the default is 600 seconds.
        public let ttl:String?

        /// The priority of the record for those that support it.
        public let prio:String?
        
        public init(
            apiKey: String,
            secretAPIKey: String,
            domain: String,
            recordID: Int,
            name: String? = nil,
            type: RecordType,
            content: String,
            ttl: Int? = nil,
            prio: String? = nil
        ) {
            self.apikey = apiKey
            self.secretapikey = secretAPIKey
            self.domain = domain
            self.recordID = recordID
            self.name = name
            self.type = type
            self.content = content
            self.ttl = ttl?.description
            self.prio = prio
        }

        public var endpointSlug : String { "dns/edit/" + domain + "/\(recordID)" }
    }
}

// MARK: Response
extension Porkbun.DNS.EditRecord {
    public struct Response : Porkbun.Response {
        public let status:String
        public let message:String?
    }
}