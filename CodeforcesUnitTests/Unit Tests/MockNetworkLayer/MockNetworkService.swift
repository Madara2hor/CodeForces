//
//  MockNetworkService.swift
//  CodeforcesTests
//
//  Created by Madara2hor on 27.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import XCTest
@testable import Code_Forces

class MockNetworkService: NetworkServiceProtocol {
    var contests: [Contest]?
    var user: User?
    var topUsers: [User]?
    
    init() {}
    
    convenience init(user: User?, contests: [Contest]?, topUsers: [User]?) {
        self.init()
        self.contests = contests
        self.user = user
        self.topUsers = topUsers
    }
    
    func getContests(gym: Bool, completion: @escaping (Result<RequestResult<Contest>?, Error>) -> Void) {
        if let contests = contests {
            if contests[0].preparedBy == "Madara2hor" {
                let result = RequestResult<Contest>(status: Status.success, result: contests, comment: "")
                completion(.success(result))
            } else {
                let result = RequestResult<Contest>(status: Status.failure, result: nil, comment: "")
                completion(.success(result))
            }
        } else {
            let error = NSError(domain: "Contests is nil!", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    func getUser(username: String, completion: @escaping (Result<RequestResult<User>?, Error>) -> Void) {
        if let user = user {
            if username == user.handle {
                let result = RequestResult<User>(status: Status.success, result: [user], comment: "")
                completion(.success(result))
            } else {
                let result = RequestResult<User>(status: Status.failure, result: nil, comment: "User not found")
                completion(.success(result))
            }
        } else {
            let error = NSError(domain: "User is nil!", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    func getTopUsers(activeOnly: Bool, completion: @escaping (Result<RequestResult<User>?, Error>) -> Void) {
        if let topUsers = topUsers {
            if topUsers[0].handle == "Madara2hor" {
                let result = RequestResult<User>(status: Status.success, result: topUsers, comment: "")
                completion(.success(result))
            } else {
                let result = RequestResult<User>(status: Status.failure, result: topUsers, comment: "User not found")
                completion(.success(result))
            }
        } else {
            let error = NSError(domain: "Top users is nil!", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}
