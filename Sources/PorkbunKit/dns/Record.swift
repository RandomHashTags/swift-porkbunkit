//
//  Record.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    public struct Record : Codable {
        public let id:String
        public let name:String
        public let type:RecordType
        public let content:String
        public let ttl:String
        public let prio:String
        public let notes:String
    }
}