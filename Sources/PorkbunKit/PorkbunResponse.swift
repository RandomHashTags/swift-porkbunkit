//
//  PorkbunResponse.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun {
    public enum Response {
    }
    public protocol ResponseProtocol : Codable {
        /// Status indicating whether or not the command was successfully processed.
        var status : String { get }

        /// Error message.
        var message : String? { get }
    }
}

extension Porkbun.ResponseProtocol {
    /// Whether the `status` equals `SUCCESS`.
    public var wasSuccess : Bool { status == "SUCCESS" }

    /// Whether the `status` equals `ERROR`.
    public var wasError : Bool   { status == "ERROR" }
}
