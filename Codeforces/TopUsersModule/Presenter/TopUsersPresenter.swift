//
//  ProfileRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol TopUsersViewProtocol: class {
    func setLoadingView()
    func removeLoadingView()
    func removeMessageSubview()
    
    func success()
    func failure(error: String?)
    
    func topUsersSorted()
}

protocol TopUsersViewPresenterProtocol: FilterTopUsersProtocol, ConnectionMonitorProtocol {
    var topUsers: [User]? { get set }
    var activeOnly: Bool! { get set }
    
    init(view: TopUsersViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func showUserDetail(user: User?, selectedIndex: Int?)
    func getTopUsers()
}

protocol FilterTopUsersProtocol: class {
    var filtredTopUsers: [User]? { get set }
    
    func sortTopUsers()
}

class TopUsersPresenter: TopUsersViewPresenterProtocol {
    
    weak var view: TopUsersViewProtocol?
    var router: RouterProtocol?
    var networkService: NetworkServiceProtocol!
    
    var topUsers: [User]?
    var filtredTopUsers: [User]?
    var activeOnly: Bool!
    
    required init(view: TopUsersViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.activeOnly = true
    }
    
    func getTopUsers() {
        DispatchQueue.main.async {
            self.view?.removeMessageSubview()
            self.view?.setLoadingView()
        }
        
        networkService.getTopUsers(activeOnly: activeOnly) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.removeLoadingView()
                
                switch result {
                case .success(let requestResult):
                    switch requestResult?.status {
                        case .success:
                            guard let resultTopUsers = requestResult?.result, !resultTopUsers.isEmpty else {
                                self.view?.failure(error: "Топ-пользователей нет...")
                                return
                            }
                            
                            self.topUsers = resultTopUsers
                            self.filtredTopUsers = resultTopUsers
                            
                            self.view?.success()
                        case .failure:
                            if self.topUsers == nil {
                                self.view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
                            }
                        case .none:
                            break
                    }
                case .failure:
                    if self.topUsers == nil {
                        self.view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
                    }
                }
            }
        }
    }
    
    func showUserDetail(user: User?, selectedIndex: Int?) {
        router?.showUserDetail(user: user, selectedIndex: selectedIndex)
    }
    
    func sortTopUsers() {
        guard let filtredUsers = self.filtredTopUsers, !filtredUsers.isEmpty else { return }
        
        self.filtredTopUsers?.reverse()
        DispatchQueue.main.async {
            self.view?.topUsersSorted()
        }
    }
    
    func connectionSatisfied() {
        if self.topUsers == nil {
            self.getTopUsers()
        }
    }
    
    func connectionUnsatisfied() {
        if self.topUsers == nil {
            DispatchQueue.main.async {
                self.view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
            }
        }
    }
    
}
