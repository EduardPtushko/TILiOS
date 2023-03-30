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
    case deleteCategory(categoryID: UUID)
    
    var path: String {
        switch self {
            case .getAllCategories:
                return  "/api/categories"
            case .createCategory(_):
                return  "/api/categories"
            case  let .deleteCategory(categoryID):
                return "/api/categories/\(categoryID)"
        }
    
    }
    
    var requestType: RequestType {
        switch self {
            case .getAllCategories:
                return  .GET
            case .createCategory:
                return    .POST
            case .deleteCategory(_):
                return .DELETE
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
