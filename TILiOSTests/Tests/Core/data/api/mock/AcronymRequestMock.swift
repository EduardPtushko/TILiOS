//
//  AcronymRequestMock.swift
//  TILiOSTests
//
//  Created by Eduard on 26.03.2023.
//

import Foundation
@testable import TILiOS

enum AcronymRequestMock: RequestProtocol {
case getAcronyms

var path: String {
    guard let path = Bundle.main.path(forResource: "AcronymsMock", ofType: "json") else {
        return ""
    }
    return path
}

var requestType: RequestType {
    .GET
}

var addAuthorizationToken: Bool {
    false
}
}
