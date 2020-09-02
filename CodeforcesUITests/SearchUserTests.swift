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
        
        let searchUserTabBarItem = app.tabBars.children(matching: .button).element(boundBy: 1)
        XCTAssertTrue(searchUserTabBarItem.exists)
        
        searchUserTabBarItem.tap()
        
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
        
        let searchUserTabBarItem = app.tabBars.children(matching: .button).element(boundBy: 1)
        XCTAssertTrue(searchUserTabBarItem.exists)
        
        searchUserTabBarItem.tap()
        
        let searchField = app.searchFields["Введите имя пользователя"]
        
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(notExistingUser)
        
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap() 
        
    }
    
//    func testClearSearchFiledButton() {
//        testFailureSearchUser()
//
//        let clearButtonQuery = app.buttons["clear"]
//        
//        expectation(for: NSPredicate(format: "exists == 1"),
//                    evaluatedWith: clearButtonQuery,
//                    handler: nil)
//        waitForExpectations(timeout: 15, handler: nil)
//        XCTAssertTrue(clearButtonQuery.exists)
//
//        clearButtonQuery.tap()
//    }
//
//    func testReloadDataButton() {
//        testSuccessSearchUser()
//
//        let reloadButtonQuery = app.buttons["arrow.2.circlepath"]
//
//        expectation(for: NSPredicate(format: "exists == 1"),
//                    evaluatedWith: reloadButtonQuery,
//                    handler: nil)
//        waitForExpectations(timeout: 15, handler: nil)
//        XCTAssertTrue(reloadButtonQuery.exists)
//
//        reloadButtonQuery.tap()
//    }

}
