//
//  UserDetailPresenter.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol UserDetailViewProtocol: AnyObject {
    
    func updateUser()
}

protocol UserDetailViewPresenterProtocol {
    
    var userHeaderModel: UserHeaderViewModel? { get }
    var userInfo: [InfoViewModel] { get }
    
    init(view: UserDetailViewProtocol, router: RouterProtocol, user: User?)
    
    func requestUser()
}

class UserDetailPresenter: UserDetailViewPresenterProtocol {
    
    var userHeaderModel: UserHeaderViewModel?
    var userInfo: [InfoViewModel] = []
    
    private weak var view: UserDetailViewProtocol!
    private var router: RouterProtocol!
    private var user: User?
    
    required init(view: UserDetailViewProtocol, router: RouterProtocol, user: User?) {
        self.view = view
        self.router = router
        self.user = user
        
        guard let user = user else {
            return
        }
        
        makeUserInfo(for: user)
    }
    
    func requestUser() {
        view.updateUser()
    }
    
    private func makeUserInfo(for user: User) {
        userHeaderModel = UserHeaderViewModel(
            image: user.titlePhoto,
            username: user.handle,
            lastOnline: user.lastOnlineTimeSeconds
        )
        
        userInfo.removeAll()
        
        if let firstName = user.firstName {
            userInfo.append(InfoViewModel(title: "Имя", info: firstName))
        }
        if let lastName = user.lastName {
            userInfo.append(InfoViewModel(title: "Фамилия", info: lastName))
        }
        if let rating = user.rating {
            userInfo.append(InfoViewModel(title: "Рейтинг", info: "\(rating)"))
        }
        
        userInfo.append(InfoViewModel(title: "Вклад", info: "\(user.contribution)"))
        userInfo.append(InfoViewModel(title: "Друзей", info: "\(user.friendOfCount)"))
        
        if let country = user.country {
            userInfo.append(InfoViewModel(title: "Страна", info: country))
        }
        if let city = user.city {
            userInfo.append(InfoViewModel(title: "Город", info: city))
        }
        if let organization = user.organization {
            userInfo.append(InfoViewModel(title: "Организация", info: organization))
        }
        if let rank = user.rank {
            userInfo.append(InfoViewModel(title: "Ранг", info: "\(rank)"))
        }
        if let email = user.email {
            userInfo.append(InfoViewModel(title: "E-mail", info: email))
        }
        if let vkId = user.vkId {
            userInfo.append(InfoViewModel(title: "ВКонтакте", info: vkId))
        }
    }
}
