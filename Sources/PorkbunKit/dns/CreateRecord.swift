//
//  CreateRecord.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    struct CreateRecord : Porkbun.AuthenticationRequired {
        let apikey:String
        let secretapikey:String

        let name:String?
        let type:RecordType
        let content:String
        let ttl:String?
        let prio:String?
    }
}

// MARK: Response
extension Porkbun.Response {
    public struct DNSCreateRecord : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?

        /// The ID of the record created.
        public let id:String?
    }
}