//
//  Category.swift
//  TILiOS
//
//  Created by Eduard on 28.03.2023.
//

import Foundation


struct Category: Codable {
    let id: UUID?
    let name: String
}

extension Category: Identifiable, Hashable {}
