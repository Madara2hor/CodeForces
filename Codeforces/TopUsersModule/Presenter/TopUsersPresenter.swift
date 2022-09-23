//
//  ProfileRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol TopUsersViewProtocol: AnyObject {
    
    func setLoadingView()
    func removeLoadingView()
    func removeMessageSubview()
    
    func success()
    func failure(error: String?)
    
    func topUsersSortedByRating()
}

protocol TopUsersViewPresenterProtocol: ConnectionMonitorProtocol {
    
    var topUsers: [User]? { get }
    var isActiveOnly: Bool! { get }
    var isHighToLow: Bool! { get }
    
    init(view: TopUsersViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func requestTopUsers(isActiveOnly: Bool?)
    func searchTopUser(_ username: String)
    func sortTopUsersByRating()
    
    func showUserDetail(user: User?, selectedIndex: Int?)
}

class TopUsersPresenter: TopUsersViewPresenterProtocol {
    
    var topUsers: [User]?
    var isActiveOnly: Bool!
    var isHighToLow: Bool!
    
    private weak var view: TopUsersViewProtocol?
    private var router: RouterProtocol?
    private var networkService: NetworkServiceProtocol!
    
    private var notFiltredTopUsers: [User]?
    
    required init(
        view: TopUsersViewProtocol,
        networkService: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.router = router
        self.networkService = networkService
        
        isActiveOnly = true
        isHighToLow = true
    }
    
    func requestTopUsers(isActiveOnly: Bool? = nil) {
        if let isActiveOnly = isActiveOnly {
            self.isActiveOnly = isActiveOnly
        }
        
        view?.removeMessageSubview()
        view?.setLoadingView()
        
        networkService.getTopUsers(activeOnly: self.isActiveOnly) { result in
            DispatchQueue.main.async { [weak self] in
                self?.view?.removeLoadingView()
                
                switch result {
                case .success(let requestResult):
                    guard let result = requestResult else {
                        return
                    }
                    
                    switch result.status {
                    case .success:
                        guard
                            let resultTopUsers = requestResult?.result,
                            resultTopUsers.isEmpty == false
                        else {
                            self?.handleFailure()
                            return
                        }
                            
                        self?.handleSuccess(with: resultTopUsers)
                    case .failure:
                        self?.handleFailure()
                    }
                case .failure:
                    self?.handleFailure()
                }
            }
        }
    }
    
    func showUserDetail(user: User?, selectedIndex: Int?) {
        router?.showUserDetail(user: user, selectedIndex: selectedIndex)
    }
    
    func searchTopUser(_ username: String) {
        let lowerSearchText = username.lowercased()
        
        topUsers = username.isEmpty
            ? notFiltredTopUsers
            : notFiltredTopUsers?.filter { $0.handle.lowercased().contains(lowerSearchText) }
    }
    
    func sortTopUsersByRating() {
        isHighToLow = !isHighToLow
        
        topUsers = topUsers?.reversed()
        
        view?.topUsersSortedByRating()
    }
    
    func connectionSatisfied() {
        if topUsers == nil {
            requestTopUsers()
        }
    }
    
    func connectionUnsatisfied() {
        if topUsers == nil {
            view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
        }
    }
    
    private func handleSuccess(with users: [User]) {
        topUsers = isHighToLow ? users : users.reversed()
        notFiltredTopUsers = isHighToLow ? users : users.reversed()
        
        view?.success()
    }
    
    private func handleFailure() {
        if topUsers == nil {
            view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
        } else {
            view?.failure(error: "Не удалось получить список топ пользователей.")
        }
    }
}
