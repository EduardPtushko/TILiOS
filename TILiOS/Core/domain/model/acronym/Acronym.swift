//
//  Acronym.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import Foundation

struct Acronym: Codable, Identifiable{
    var id: UUID?
    let short: String
    let long: String
    let user: AcronymUser
}

extension Acronym {
    static let mockAcronyms = [
        Acronym(id: UUID(), short: "OMG", long: "Oh My God!", user: AcronymUser(id: UUID())),
//        Acronym(id: UUID(), short: "WTF", long: "What The Fork", user: AcronymUser(id: UUID())),
//        Acronym(id: UUID(), short: "AAMOF", long: "As A Matter Of Fact", user: AcronymUser(id: UUID()))
    ]
}

struct AcronymUser: Codable {
    let id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}

struct CreateAcronymData: Codable {
  let short: String
  let long: String
  let userID: UUID
}

//extension Acronym {
//  func toCreateData() -> CreateAcronymData {
//    CreateAcronymData(short: self.short, long: self.long, userID: self.userID)
//  }
//}
