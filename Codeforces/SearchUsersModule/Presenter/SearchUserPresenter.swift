//
//  SearchRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol SearchUserViewProtocol: class {
    func setLoadingView()
    func removeLoadingView()
    func removeMessageSubview()
    
    func success()
    func failure(error: String?)
}

protocol SearchUserViewPresenterProtocol: class {
    var user: User? { get set }
    var searchedUser: String? { get set }
    init(view: SearchUserViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getUser()
}

class SearchUserPresenter: SearchUserViewPresenterProtocol {
    weak var view: SearchUserViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var searchedUser: String?
    var user: User?
    
    required init(view: SearchUserViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func getUser() {
        DispatchQueue.main.async {
            self.view?.removeMessageSubview()
            self.view?.setLoadingView()
        }
        
        networkService.getUser(username: searchedUser ?? "") { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.removeLoadingView()
                
                switch result {
                    case .success(let requsetResult):
                        switch requsetResult?.status {
                        case .success:
                            guard let resultUser = requsetResult?.result?[0] else {
                                self.view?.failure(error: "Ошибка получения пользователя")
                                return
                            }
                            self.user = resultUser
                            
                            self.view?.success()
                        case .failure:
                            self.user = nil
                            self.view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
                        case .none:
                            break
                    }
                case .failure:
                        self.view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
                }
            }
                
            
        } 
    }

}
