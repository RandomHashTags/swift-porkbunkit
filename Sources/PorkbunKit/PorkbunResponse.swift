//
//  PorkbunResponse.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun {
    public protocol Response : Codable {
        /// A status indicating whether or not the command was successfuly processed.
        var status : String { get }

        /// The error message.
        var message : String? { get }
    }
}

extension Porkbun.Response {
    public var wasSuccess : Bool { status == "SUCCESS" }
    public var wasError : Bool { status == "ERROR" }
}
