//
//  OktaTrackUITests.swift
//  OktaTrackUITests
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import XCTest
@testable import OktaTrack

class OktaTrackUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }

    func testContributorsVisible() {

        let app = XCUIApplication()
        app.launch()
        wait(for: [], timeout: 3)
        XCTAssertTrue(app.tables.buttons["vsouza/awesome-ios\nawesome-ios"].exists)

        app.tables.buttons["vsouza/awesome-ios\nawesome-ios"].tap()

        XCTAssertFalse(app.tables["Empty list"].exists, "Contributors list should not be empty")
    }
}
