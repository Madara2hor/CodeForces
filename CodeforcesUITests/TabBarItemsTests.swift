//
//  TabBarItemsTests.swift
//  CodeforcesUITests
//
//  Created by Madara2hor on 01.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest

class TabBarItemsTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        
    }

    func testTabBarItems() {
        let tabBarsQuery = XCUIApplication().tabBars
        
        let secondTabBarItem = tabBarsQuery.children(matching: .button).element(boundBy: 1)
        XCTAssertTrue(secondTabBarItem.exists)
        secondTabBarItem.tap()
                
        let thirdTabBarItem = tabBarsQuery.children(matching: .button).element(boundBy: 2)
        XCTAssertTrue(thirdTabBarItem.exists)
        thirdTabBarItem.tap()
        
        let firstTabBarItem = tabBarsQuery.children(matching: .button).element(boundBy: 0)
        XCTAssertTrue(firstTabBarItem.exists)
        firstTabBarItem.tap()
    }

}
