//
//  CategoriesRequest.swift
//  TILiOS
//
//  Created by Eduard on 29.03.2023.
//

import Foundation

enum CategoriesRequest: RequestProtocol {
    case getAllCategories
    case createCategory(name: String)
    
    var path: String {
        "/api/categories"
    }
    
    var requestType: RequestType {
        switch self {
            case .getAllCategories:
                return  .GET
            case .createCategory:
                return    .POST
        }
    }
    
    var params: [String : Any] {
        switch self {
            case  .createCategory(let name):
                return ["name": name]
            default:
                return [:]
        }
    }
    
    var addAuthorizationToken: Bool {
        false
    }
    
}
