//
//  APIManagerMock.swift
//  TILiOSTests
//
//  Created by Eduard on 26.03.2023.
//

import Foundation
@testable import TILiOS


struct APIManagerMock: APIManagerProtocol {
    func perform(_ request: RequestProtocol, authToken: String) async throws ->  Data {
        
        return try Data(contentsOf: URL(fileURLWithPath: request.path ), options: .mappedIfSafe)
    }
    
    
}
