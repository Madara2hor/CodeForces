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
        
        userInfo = user.getInfoModel()
    }
}
