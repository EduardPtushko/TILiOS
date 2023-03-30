//
//  UsersRequest.swift
//  TILiOS
//
//  Created by Eduard on 27.03.2023.
//

import Foundation

enum UsersRequest: RequestProtocol {
    case getAllUser
    case createUser(name: String, username: String)
    case deleteUser(userID: UUID)
    case getUser(userID: UUID)
    
    var requestType: RequestType {
        switch self {
            case .getAllUser,
                    .getUser(_):
                return .GET
            case .createUser(_,_):
                return .POST
            case .deleteUser(_):
                  return .DELETE
        }
    }
    
    
    var path: String {
        switch self {
            case .getAllUser, .createUser(_,_):
                return "/api/users"
            case .deleteUser(userID: let userID),
                    .getUser(userID: let userID):
                return "/api/users/\(userID)"
        }
    }
    
    var params: [String : Any] {
        switch self {
            case let .createUser(name, username):
                return ["name": name, "username": username]
            default:
              return  [:]
        }
    }
    
    var addAuthorizationToken: Bool { false }
}
