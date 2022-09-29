//
//  User.swift
//  Codeforces
//
//  Created by Madara2hor on 06.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    
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

extension User {
    
    func getInfoModel() -> [InfoViewModel] {
        var userInfo: [InfoViewModel] = []
        
        if let firstName = firstName {
            userInfo.append(InfoViewModel(title: "Имя", info: firstName))
        }
        if let lastName = lastName {
            userInfo.append(InfoViewModel(title: "Фамилия", info: lastName))
        }
        if let rating = rating {
            userInfo.append(InfoViewModel(title: "Рейтинг", info: "\(rating)"))
        }
        
        userInfo.append(InfoViewModel(title: "Вклад", info: "\(contribution)"))
        userInfo.append(InfoViewModel(title: "Друзей", info: "\(friendOfCount)"))
        
        if let country = country {
            userInfo.append(InfoViewModel(title: "Страна", info: country))
        }
        if let city = city {
            userInfo.append(InfoViewModel(title: "Город", info: city))
        }
        if let organization = organization {
            userInfo.append(InfoViewModel(title: "Организация", info: organization))
        }
        if let rank = rank {
            userInfo.append(InfoViewModel(title: "Ранг", info: "\(rank)"))
        }
        if let email = email {
            userInfo.append(InfoViewModel(title: "E-mail", info: email))
        }
        if let vkId = vkId {
            userInfo.append(InfoViewModel(title: "ВКонтакте", info: vkId))
        }
        
        return userInfo
    }
}
