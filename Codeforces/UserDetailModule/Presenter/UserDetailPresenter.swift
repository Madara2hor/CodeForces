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
    var userInfo: [String] { get }
    
    init(view: UserDetailViewProtocol, router: RouterProtocol, user: User?)
    
    func requestUser()
}

class UserDetailPresenter: UserDetailViewPresenterProtocol {
    
    var userHeaderModel: UserHeaderViewModel?
    var userInfo: [String] = []
    
    private weak var view: UserDetailViewProtocol?
    private var router: RouterProtocol?
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
        view?.updateUser()
    }
    
    private func makeUserInfo(for user: User) {
        userHeaderModel = UserHeaderViewModel(
            image: user.titlePhoto,
            username: user.handle,
            isOnline: user.lastOnlineTimeSeconds == .zero
        )
        
        userInfo.removeAll()
        
        if let firstName = user.firstName {
            userInfo.append("Имя: \(firstName)")
        }
        if let lastName = user.lastName {
            userInfo.append("Фамилия: \(lastName)")
        }
        
        if let rating = user.rating {
            userInfo.append("Рейтинг: \(rating)")
        }
        
        userInfo.append("Вклад: \(user.contribution)")
        userInfo.append("Друзья: \(user.friendOfCount)")
        
        if let country = user.country {
            userInfo.append("Страна: \(country)")
        }
        if let city = user.city {
            userInfo.append("Город: \(city)")
        }
        if let organization = user.organization {
            userInfo.append("Организация: \(organization)")
        }
        if let rank = user.rank {
            userInfo.append("Ранг: \(rank)")
        }
        if let email = user.email {
            userInfo.append("E-mail: \(email)")
        }
        if let vkId = user.vkId {
            userInfo.append("ВКонтакте: \(vkId)")
        }
    }
}
