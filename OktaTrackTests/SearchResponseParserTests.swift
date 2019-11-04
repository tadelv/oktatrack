//
//  SearchResponseParserTests.swift
//  OktaTrackTests
//
//  Created by Vid Tadel on 31/10/2019.
//  Copyright © 2019 Delta96. All rights reserved.
//

import XCTest
@testable import OktaTrack

class SearchResponseParserTests: XCTestCase {
    
    enum SampleType {
        case SearchItems
        case Contributors
    }
    
    func retrieveJSONFor(type: SampleType) -> Data? {
        var resName = ""
        switch type {
        case .SearchItems:
            resName = "swift_repos_sample"
        case .Contributors:
            resName = "swift_contributors_sample"
        }

        guard let path = Bundle(for:SearchResponseParserTests.self).path(forResource: resName, ofType: "json") else {
            return nil
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        }
        catch {
            print("Could not load \(resName) json: \(error)")
            XCTFail("JSON data is inaccessible")
        }
        return nil
    }
    
    func testParseSearchItems() {
        guard let data = retrieveJSONFor(type: .SearchItems) else {
            return
        }
        let parser = SearchResponseParser(jsonData: data)
        let items = parser.decodeRepositories()
        XCTAssertTrue(items.count > 0)
    }
    
    func testParseContributors() {
        guard let data = retrieveJSONFor(type: .Contributors) else {
            return
        }
        let parser = SearchResponseParser(jsonData: data)
        let contributors = parser.decodeContributors()
        XCTAssertTrue(contributors.count > 0)
    }
}
