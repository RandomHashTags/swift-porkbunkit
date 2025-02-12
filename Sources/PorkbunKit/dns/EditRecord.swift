//
//  EditRecord.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    struct EditRecord : Porkbun.AuthenticationRequired {
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
    public struct DNSEditRecord : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?
    }
}