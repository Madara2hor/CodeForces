//
//  RequestResult.swift
//  Twitter
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct RequestResult<T: Codable>: Codable {
    var status: Status
    var result: [T]?
    var comment: String?
}

enum Status: String, Codable {
    case failure = "FAILED"
    case success = "OK"
}
