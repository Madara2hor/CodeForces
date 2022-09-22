//
//  MessagesRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol UserDetailViewProtocol: AnyObject {
    
    func setUser(user: User?)
}

protocol UserDetailViewPresenterProtocol {
    
    init(view: UserDetailViewProtocol, router: RouterProtocol, user: User?)
    
    func setUser()
}

class UserDetailPresenter: UserDetailViewPresenterProtocol {
    
    private weak var view: UserDetailViewProtocol?
    private var router: RouterProtocol?
    private var user: User?
    
    required init(view: UserDetailViewProtocol, router: RouterProtocol, user: User?) {
        self.view = view
        self.router = router
        self.user = user
    }
    
    func setUser() {
        self.view?.setUser(user: user)
    }
}
