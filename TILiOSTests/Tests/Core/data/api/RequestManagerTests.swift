//
//  RequestManagerTests.swift
//  TILiOSTests
//
//  Created by Eduard on 26.03.2023.
//

import XCTest
@testable import TILiOS

final class RequestManagerTests: XCTestCase {
    private var requestManager: RequestManagerProtocol?
    
    override func setUp() {
        super.setUp()
        requestManager = RequestManager(apiManager: APIManagerMock())
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestAcronyms() async throws {
        
        guard let acronyms: [Acronym] = try await requestManager?.perform(AcronymRequestMock.getAcronyms) else {
            XCTFail("Didn't get data from the request manager")
            return
        }
        
        let first = acronyms.first
        let last = acronyms.last
        
        XCTAssertEqual(first?.short, "AAMOF")
        XCTAssertEqual(first?.long, "As A Matter Of Fact")
        
        XCTAssertEqual(last?.short, "WTF")
        XCTAssertEqual(last?.long, "What the fork")
        
    }


}
