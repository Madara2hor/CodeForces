//
//  ProfileRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol TopUsersViewProtocol: class {
    func success()
    func failure(error: String?)
    func topUsersSorted()
}

protocol TopUsersViewPresenterProtocol: FilterTopUsersProtocol {
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
        self.activeOnly = false
        
        getTopUsers()
    }
    
    func getTopUsers() {
        networkService.getTopUsers(activeOnly: activeOnly) { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let requestResult):
                    switch requestResult?.status {
                        case .success:
                            self.topUsers = requestResult?.result
                            self.filtredTopUsers = requestResult?.result
                            self.view?.success()
                        case .failure:
                            self.topUsers = nil
                            self.view?.failure(error: requestResult?.comment)
                        case .none:
                            break
                    }
                case .failure(let error):
                    self.view?.failure(error: error.localizedDescription)
                }
            }
        }
    }
    
    func showUserDetail(user: User?, selectedIndex: Int?) {
        router?.showUserDetail(user: user, selectedIndex: selectedIndex)
    }
    
    func sortTopUsers() {
        filtredTopUsers?.reverse()
        
        DispatchQueue.main.async {
            self.view?.topUsersSorted()
        }
    }
}
