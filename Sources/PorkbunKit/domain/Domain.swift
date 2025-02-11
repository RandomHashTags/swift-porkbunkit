//
//  Domain.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun {
    public struct Domain : Codable {
        public let domain:String
        public let status:String
        public let tld:String
        public let createDate:String
        public let expireDate:String
        public let securityLock:String // bool
        public let whoisPrivacy:String // bool
        public let autoRenew:UInt8 // bool
        public let notLocal:UInt8 // bool
        public let labels:[PorkbunLabel]
    }
}