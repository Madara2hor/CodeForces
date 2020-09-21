//
//  ContestTests.swift
//  CodeforcesUITests
//
//  Created by Madara2hor on 21.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest

class ContestTests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        
    }
    
    func testShowContestDetail() {
        
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        cell.waitForExistence(timeout: 30)
        XCTAssertTrue(cell.exists)
        cell.tap()
    }
    
    func testContestsMenuOpenClose() {
        let menu = app.buttons["menu"]
        XCTAssertTrue(menu.exists)
        menu.tap()
    }

}
