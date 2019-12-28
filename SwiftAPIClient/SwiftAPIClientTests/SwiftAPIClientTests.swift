//
//  SwiftAPIClientTests.swift
//  SwiftAPIClientTests
//
//  Created by 前田　和樹 on 2019/12/28.
//  Copyright © 2019 kzk_maeda. All rights reserved.
//

import XCTest
@testable import SwiftAPIClient

class SwiftAPIClientTests: XCTestCase {

    func testRequest() {
        let input: Request = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        WebAPI.call(with: input)
    }

    func testResponse() {
        let response : Response = (
            statusCode : .ok,
            headers: [:],
            payload: "this is a response text".data(using: .utf8)!
        )
        let errorOrZen = GitHubZen.from(response: response)
        
        switch errorOrZen {
        case let .left(error):
            XCTFail()
        case let .right(zen):
            XCTAssertEqual(zen.text, "this is a response text")
        }
    }
    
    func testRequestAndResponse() {
        let expectation = self.expectation(description: "非同期を待つ")
        let input: Request = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                XCTFail("\(connectionError)")
            case let .hasResponse(response):
                let errorOrZen = GitHubZen.from(response: response)
                XCTAssertNotNil(errorOrZen.right)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
