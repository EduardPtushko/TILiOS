//
//  User.swift
//  TILiOS
//
//  Created by Eduard on 27.03.2023.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID?
    let name: String
    let username: String
}
