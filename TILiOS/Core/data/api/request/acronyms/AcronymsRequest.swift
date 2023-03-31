//
//  AcronymsRequest.swift
//  Acronyms
//
//  Created by Eduard on 26.03.2023.
//

import Foundation

enum AcronymsRequest: RequestProtocol {
    case getAcronyms
    case createAcronym(short: String, long: String,  userID: UUID)
    
    var path: String {
        "/api/acronyms"
    }
    
    var requestType: RequestType {
        switch self {
            case .getAcronyms:
                return  .GET
            case .createAcronym(_, _, _):
                return  .POST
        }
    }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    var params: [String: Any] {
        switch self {
            case let .createAcronym(short, long, userID):
                return ["short": short, "long": long,  "userID": userID.uuidString]
            case .getAcronyms:
                return  [:]
        }
    }
}


enum AcronymIDRequest: RequestProtocol {
    case getAcronym(acronymID: UUID)
    case updateAcronym(short: String, long: String, acronymID: UUID)
    case deleteAcronym(acronymID: UUID)
    case getAcronymCategories(acronymID: UUID)
    case addAcronymToCategory(acronymID: UUID, categoryID: UUID)
    case removeAcronymFromCategory(acronymID: UUID, categoryID: UUID)
    
    var path: String {
        switch self {
            case let .getAcronym(acronymID),
                let .updateAcronym(_, _, acronymID),
                let .deleteAcronym(acronymID):
                return "/api/acronyms/\(acronymID)"
            case .getAcronymCategories(acronymID: let acronymID):
                return "/api/acronyms/\(acronymID)/categories"
            case .addAcronymToCategory(acronymID: let acronymID, categoryID: let categoryID),
                .removeAcronymFromCategory(acronymID: let acronymID, categoryID: let categoryID):
                return "/api/acronyms/\(acronymID)/categories/\(categoryID)"
        }
        
    }
    
    var requestType: RequestType {
        switch self {
            case .getAcronym(_),
                .getAcronymCategories(_),
                .addAcronymToCategory(_,_):
                return .GET
            case  .updateAcronym(_, _, _):
                return .PUT
            case  .deleteAcronym(_),
                    .removeAcronymFromCategory(_,_):
                return .DELETE
        }
        
    }
    
    var params: [String: Any] {
        switch self {
            case let .updateAcronym(short, long, _):
                return ["short": short, "long": long]
            default:
                return  [:]
        }
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}

