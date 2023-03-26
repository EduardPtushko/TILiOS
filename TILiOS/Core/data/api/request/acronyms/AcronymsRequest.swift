//
//  AcronymsRequest.swift
//  Acronyms
//
//  Created by Eduard on 26.03.2023.
//

import Foundation

enum AcronymsRequest: RequestProtocol {
    case getAcronyms
    
    var path: String {
        "/api/acronyms"
    }
    
    var requestType: RequestType {
        .GET
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}

enum CreateAcronymRequest: RequestProtocol {
    case createAcronym(short: String, long: String)
    
    var path: String {
        "/api/acronyms"
    }
    
    var requestType: RequestType {
        .POST
    }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    var params: [String: Any] {
        switch self {
            case let .createAcronym(short, long):
                return ["short": short, "long": long]
        }
    }
}
