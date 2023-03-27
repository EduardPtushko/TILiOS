//
//  Acronym.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import Foundation

struct Acronym: Codable, Identifiable, Hashable {
    var id: UUID?
    let short: String
    let long: String
    
}

extension Acronym {
    static let mockAcronyms = [
        Acronym(id: UUID(), short: "OMG", long: "Oh My God!"),
        Acronym(id: UUID(), short: "WTF", long: "What The Fork"),
        Acronym(id: UUID(), short: "AAMOF", long: "As A Matter Of Fact"),
    ]
}
