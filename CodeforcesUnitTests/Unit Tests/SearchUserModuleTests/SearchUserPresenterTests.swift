//
//  SearchUserModuleTests.swift
//  CodeforcesTests
//
//  Created by Madara2hor on 28.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest
@testable import Code_Forces

class SearchUserModuleTests: XCTestCase {

    var view: SearchUserViewProtocol!
    var presenter: SearchUserPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var user: User?
    
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
    
    func initPresenter(searchedUser: String) {
        user = User(handle: "Madara2hor",
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
        
        view = MockSearchUserView()
        networkService = MockNetworkService(user: user, contests: nil, topUsers: nil)
        presenter = SearchUserPresenter(view: view, networkService: networkService, router: router)
        presenter.searchedUser = searchedUser
        presenter.getUser()
    }
    
    func testGetSuccessUser() {
        initPresenter(searchedUser: "Madara2hor")
        
        var catchUser: User?
        var catchRequest: RequestResult<User>?
        
        networkService.getUser(username: presenter.searchedUser ?? "") { result in
            switch result {
            case .success(let requestResult):
                switch requestResult?.status {
                case .success:
                    catchRequest = requestResult
                    catchUser = requestResult?.result?[0]
                    self.view.success()
                default:
                    catchUser = nil
                    catchRequest = requestResult
                    self.view?.failure(error: requestResult?.comment)
                }
            case .failure(let error):
                self.view?.failure(error: error.localizedDescription)
            }
        }
        
        XCTAssertEqual(catchRequest?.status, Status.success)
        XCTAssertNotNil(catchUser)
        XCTAssertEqual(catchUser, self.user)
    }
        
    func testGetFailureRequestResult() {
        initPresenter(searchedUser: "Tester")

        var catchUser: User?
        var catchRequest: RequestResult<User>?

        networkService.getUser(username: presenter.searchedUser ?? "") { result in
            switch result {
            case .success(let requestResult):
                switch requestResult?.status {
                case .failure:
                    catchUser = nil
                    catchRequest = requestResult
                    self.view?.failure(error: requestResult?.comment)
                default:
                    catchRequest = requestResult
                    catchUser = requestResult?.result?[0]
                    self.view.success()
                }
            case .failure(let error):
                self.view?.failure(error: error.localizedDescription)
            }
        }

        XCTAssertEqual(catchRequest?.status, Status.failure)
        XCTAssertNil(catchUser)
    }

    func testGetFailureUser() {

        view = MockSearchUserView()
        networkService = MockNetworkService()
        presenter = SearchUserPresenter(view: view, networkService: networkService, router: router)
        presenter.getUser()

        var catchError: Error?

        networkService.getUser(username: presenter.searchedUser ?? "") { result in
            switch result {
            case .success(let user):
                print(user?.result)
            case .failure(let error):
                self.view.failure(error: error.localizedDescription)
                catchError = error
            }
        }

        XCTAssertNotNil(catchError)
    }

}


