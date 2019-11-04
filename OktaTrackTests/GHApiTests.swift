//
//  GHApiTests.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import XCTest
@testable import OktaTrack

class GHApiTests: XCTestCase {

//    func testFetchRepositories() {
//        let api = GHApi()
//        let repos = api.fetchRepositories()
//
//    }
    
    func testFetchContributors() {
        let exp = self.expectation(description: "async wait")
        var contribs: [Contribution] = []
        contribs = GHApi.fetchContributionsAsync({ (contributions) in
            print(contributions)
        })
        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(contribs)
    }
}
