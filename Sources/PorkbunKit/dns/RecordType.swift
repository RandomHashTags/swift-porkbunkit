//
//  RecordType.swift
//
//
//  Created by Evan Anderson on 2/11/25.
//

extension Porkbun.DNS {
    public enum RecordType : String, Codable {
        case a = "A"
        case mx = "MX"
        case cname = "CNAME"
        case alias = "ALIAS"
        case txt = "TXT"
        case ns = "NS"
        case aaaa = "AAAA"
        case srv = "SRV"
        case tlsa = "TLSA"
        case caa = "CAA"
        case https = "HTTPS"
        case svcb = "SVCB"
    }
}