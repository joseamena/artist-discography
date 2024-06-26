//
//  dt_discographyUITestsLaunchTests.swift
//  dt-discographyUITests
//
//  Created by Jose A. Mena on 3/27/24.
//

import XCTest

final class dt_discographyUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testShowDiscographyView() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Discography"].tap()
        XCTAssertTrue(app.staticTexts["Discography"].firstMatch.waitForExistence(timeout: 3))
    }
}
