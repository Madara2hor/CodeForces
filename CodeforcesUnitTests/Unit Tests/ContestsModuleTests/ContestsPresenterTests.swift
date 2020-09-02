//
//  CodeforcesTests.swift
//  CodeforcesTests
//
//  Created by Madara2hor on 27.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest
@testable import Code_Forces

class ContestsPresenterTests: XCTestCase {
    
    var view: ContestsViewProtocol!
    var presenter: ContestsPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var contests = [Contest]()

    override func setUpWithError() throws {
        super.setUp()
        let tabBarC = UITabBarController()
        let moduleBuilder = ModuleBuilder()
        router = Router(tabBarController: tabBarC, moduleBuilder: moduleBuilder)
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        networkService = nil
        router = nil
        super.tearDown()
    }
    
    func initPresenter(preparedBy: String) {
        let contest = Contest(id: 1,
                              name: "Contest #1",
                              type: ContestType.CF,
                              phase: ContestPhase.CODING,
                              frozen: false,
                              durationSeconds: 0,
                              startTimeSeconds: nil,
                              relativeTimeSeconds: nil,
                              preparedBy: preparedBy,
                              websiteUrl: nil,
                              description: "Testing XCUITests",
                              difficulty: nil,
                              kind: nil,
                              icpcRegion: nil,
                              country: nil,
                              city: nil,
                              season: nil)
        contests.append(contest)
        
        view = MockContestsView()
        networkService = MockNetworkService(user: nil, contests: contests, topUsers: nil)
        presenter = ContestsPresenter(view: view, networkService: networkService, router: router)
    }
    
    func testGetSuccessContests() {
        initPresenter(preparedBy: "Madara2hor")
        
        var catchContests: [Contest]?
        var catchRequest: RequestResult<Contest>?
        
        networkService.getContests(gym: false) { result in
            switch result {
            case .success(let requestResult):
                switch requestResult?.status {
                case .success:
                    catchRequest = requestResult
                    catchContests = requestResult?.result
                    self.view.success()
                default:
                    break
                }
            case .failure(let error):
                self.view.failure(error: error.localizedDescription)
            }
        }
        
        XCTAssertEqual(catchRequest?.status, Status.success)
        XCTAssertNotEqual(catchContests?.count, 0)
        XCTAssertEqual(catchContests?.count, contests.count)
    }
    
    func testGetFailureRequestResult() {
        initPresenter(preparedBy: "Tester")
        
        var catchContests: [Contest]?
        var catchRequest: RequestResult<Contest>?
        
        networkService.getContests(gym: false) { result in
            switch result {
            case .success(let requestResult):
                switch requestResult?.status {
                case .failure:
                    catchContests = nil
                    catchRequest = requestResult
                    self.view?.failure(error: requestResult?.comment)
                default:
                    catchRequest = requestResult
                    catchContests = requestResult?.result
                    self.view.success()
                }
            case .failure(let error):
                self.view.failure(error: error.localizedDescription)
            }
        }
        
        XCTAssertEqual(catchRequest?.status, Status.failure)
        XCTAssertNil(catchContests)
    }
        
    func testGetFailureContests() {
        
        view = MockContestsView()
        networkService = MockNetworkService()
        presenter = ContestsPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        
        networkService.getContests (gym: false) { result in
            switch result {
            case .success(let contests):
                print(contests?.result)
            case .failure(let error):
                catchError = error
                self.view.failure(error: error.localizedDescription)
            }
        }
        
        XCTAssertNotNil(catchError)
    }

}
