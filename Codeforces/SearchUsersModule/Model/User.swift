//
//  User.swift
//  Codeforces
//
//  Created by Madara2hor on 06.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct User: Codable {
    var handle: String
    var email: String?
    var vkId: String?
    var openId: String?
    var firstName: String?
    var lastName: String?
    var country: String?
    var city: String?
    var organization: String?
    var contribution: Int
    var rank: String?
    var rating: Int?
    var maxRank: String?
    var maxRating: Int?
    var lastOnlineTimeSeconds: Int
    var registrationTimeSeconds: Int
    var friendOfCount: Int
    var avatar: String
    var titlePhoto: String
}
