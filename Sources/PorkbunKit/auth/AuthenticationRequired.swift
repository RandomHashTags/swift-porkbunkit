//
//  AuthenticationRequired.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun {
    public protocol AuthenticationRequired : Request {
        /// Your API key.
        var apikey : String { get }

        /// Your secret API key.
        var secretapikey : String { get }
    }
}
