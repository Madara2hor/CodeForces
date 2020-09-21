//
//  TopUsersTests.swift
//  CodeforcesUITests
//
//  Created by Madara2hor on 21.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest

class TopUsersTests: XCTestCase {
    
    let app = XCUIApplication()
    let tabBarsQuery = XCUIApplication().tabBars

    override func setUpWithError() throws {
        continueAfterFailure = false

        XCUIApplication().launch()

    }

    override func tearDownWithError() throws {
        
    }
    
//    func testTopUserDetail() {
//        let firstUserCell = app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
//        firstUserCell.waitForExistence(timeout: 90)
//        XCTAssertTrue(firstUserCell.exists)
//        firstUserCell.tap()
//    }

    func testTopUsersMenuOpenClose() {
        let thirdTabBarItem = tabBarsQuery.children(matching: .button).element(boundBy: 2)
        XCTAssertTrue(thirdTabBarItem.exists)
        thirdTabBarItem.tap()
        
        let menu = app.buttons["menu"]
        XCTAssertTrue(menu.exists)
        menu.tap()
    }

    

}
