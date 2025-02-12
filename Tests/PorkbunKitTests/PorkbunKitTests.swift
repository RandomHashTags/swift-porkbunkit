//
//  PorkbunKitTests.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

#if compiler(>=6.0)

import Testing
@testable import PorkbunKit

@Test func example() async throws {
    try PorkbunAPIKeys.load()
    let client:PorkbunClient = PorkbunClient(apiKey: PorkbunAPIKeys.apiKey, secretAPIKey: PorkbunAPIKeys.secretAPIKey)
    let response = try await client.listAll()
}

#endif

protocol APIKeys {
    func load() throws
}
extension APIKeys {
    func load() throws {
        fatalError("No API keys loaded")
    }
}

enum PorkbunAPIKeys : APIKeys {
    static var apiKey:String = ""
    static var secretAPIKey:String = ""
}