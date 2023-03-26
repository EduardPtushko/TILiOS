//
//  Acronym.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import Foundation

struct Acronym: Codable, Identifiable {
    var id: UUID?
    let short: String
    let long: String
    
}
