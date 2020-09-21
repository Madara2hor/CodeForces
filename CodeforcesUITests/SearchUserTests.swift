//
//  ContestDetailTests.swift
//  CodeforcesUITests
//
//  Created by Madara2hor on 01.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest

class SearchUserTests: XCTestCase {
    
    let app = XCUIApplication()
    let userHandle = "Madara2hor"
    let notExistingUser = "JustNotExistUser"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        
    }

    func testSuccessSearchUser() {
        
        goToSearchUserTab()
        
        let searchField = app.searchFields["Введите имя пользователя"]
        
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(userHandle)
        
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        let handleQuery = app.scrollViews.otherElements.staticTexts[userHandle]
        
        expectation(for: NSPredicate(format: "exists == 1"),
                    evaluatedWith: handleQuery,
                    handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(handleQuery.exists)
        
        XCTAssertEqual(userHandle, handleQuery.label)
    }
    
    func testFailureSearchUser() {
        
        goToSearchUserTab()
        
        let searchField = app.searchFields["Введите имя пользователя"]
        
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(notExistingUser)
        
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let labelQuery = app/*@START_MENU_TOKEN@*/.staticTexts["Пользователь не найден"]/*[[".otherElements[\"messageView\"].staticTexts[\"Пользователь не найден\"]",".staticTexts[\"Пользователь не найден\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        expectation(for: NSPredicate(format: "exists == 1"),
                    evaluatedWith: labelQuery,
                    handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(labelQuery.exists)
    }
    
    func testSearchUserMenuOpenClose() {
        goToSearchUserTab()
       
        let menu = app.buttons["menu"]
        XCTAssertTrue(menu.exists)
        menu.tap()
        
    }
    
    func goToSearchUserTab() {
        let secondTabBarItem = app.tabBars.children(matching: .button).element(boundBy: 1)
        XCTAssertTrue(secondTabBarItem.exists)
        secondTabBarItem.tap()
    }

}
