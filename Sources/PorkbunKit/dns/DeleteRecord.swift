//
//  DeleteRecord.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    /// Delete a specific DNS record.
    public struct DeleteRecord : Porkbun.AuthenticationRequired {
        public let apikey:String
        public let secretapikey:String

        /// Your domain.
        public let domain:String

        public let recordID:Int
    }
}

// MARK: Response
extension Porkbun.Response {
    public struct DNSDeleteRecord : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?
    }
}