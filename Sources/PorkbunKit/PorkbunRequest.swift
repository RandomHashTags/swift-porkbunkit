//
//  PorkbunRequest.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun {
    public protocol Request : Codable {
        var endpointSlug : String { get }
    }
}
