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
    
    var requestType: RequestType {
        switch self {
            case .getAllUser:
                return .GET
            case .createUser(_,_):
                return .POST
        }
    }
    
    
    var path: String {
        switch self {
            case .getAllUser, .createUser(_,_):
                return "/api/users"
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
