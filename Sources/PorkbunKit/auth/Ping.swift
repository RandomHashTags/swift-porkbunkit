//
//  Authentication.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

// MARK: Response
extension Porkbun.Response {
    public struct Ping : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?
        public let yourIp:String?
    }
}