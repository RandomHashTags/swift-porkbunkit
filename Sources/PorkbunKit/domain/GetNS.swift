//
//  GetNS.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

// MARK: Response
extension Porkbun.Response {
    public struct GetNS : Porkbun.ResponseProtocol {
        public let status:String
        public let message:String?

        /// An array of name server host names.
        public let ns:[String]?
    }
}