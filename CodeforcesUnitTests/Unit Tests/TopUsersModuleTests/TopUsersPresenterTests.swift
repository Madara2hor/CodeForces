//
//  TopUsersPresenterTests.swift
//  CodeforcesTests
//
//  Created by Madara2hor on 28.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest
@testable import Code_Forces

class TopUsersPresenterTests: XCTestCase {

    var view: TopUsersViewProtocol!
    var presenter: TopUsersPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var topUsers = [User]()

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
    
    func initPresenter(handle: String) {
        let user = User(handle: handle,
                        email: nil,
                        vkId: nil,
                        openId: nil,
                        firstName: nil,
                        lastName: nil,
                        country: nil,
                        city: nil,
                        organization: nil,
                        contribution: 0,
                        rank: nil,
                        rating: nil,
                        maxRank: nil,
                        maxRating: nil,
                        lastOnlineTimeSeconds: 0,
                        registrationTimeSeconds: 0,
                        friendOfCount: 0,
                        avatar: "",
                        titlePhoto: "")
        topUsers.append(user)
        
        view = MockTopUsersView()
        networkService = MockNetworkService(user: nil, contests: nil, topUsers: topUsers)
        presenter = TopUsersPresenter(view: view, networkService: networkService, router: router)
    }
    
    func testGetSuccessTopUsers() {
        
        initPresenter(handle: "Madara2hor")
        
        var catchTopUsers: [User]?
        var catchRequest: RequestResult<User>?
        
        networkService.getTopUsers(activeOnly: false) { result in
            switch result {
            case .success(let requestResult):
                switch requestResult?.status {
                case .success:
                    catchRequest = requestResult
                    catchTopUsers = requestResult?.result
                    self.view.success()
                default:
                    break
                }
            case .failure(let error):
                print(error)
            }
        }
        
        XCTAssertEqual(catchRequest?.status, Status.success)
        XCTAssertNotEqual(catchTopUsers?.count, 0)
        XCTAssertEqual(catchTopUsers?.count, topUsers.count)
    }
    
    func testGetFailureRequestResult() {
        initPresenter(handle: "Tester")
        
        var catchTopUsers: [User]?
        var catchRequest: RequestResult<User>?
        
        networkService.getTopUsers(activeOnly: false) { result in
            switch result {
            case .success(let requestResult):
                switch requestResult?.status {
                case .failure:
                    catchTopUsers = nil
                    catchRequest = requestResult
                    self.view?.failure(error: requestResult?.comment)
                default:
                    break
                }
            case .failure(let error):
                print(error)
            }
        }
        
        XCTAssertEqual(catchRequest?.status, Status.failure)
        XCTAssertNil(catchTopUsers)
    }
    
    func testGetFailureTopUsers() {
        
        view = MockTopUsersView()
        networkService = MockNetworkService()
        presenter = TopUsersPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        
        networkService.getContests (gym: false) { result in
            switch result {
            case .success(let contests):
                print(contests?.result)
            case .failure(let error):
                catchError = error
            }
        }
        
        XCTAssertNotNil(catchError)
    }
    
    
    
}
