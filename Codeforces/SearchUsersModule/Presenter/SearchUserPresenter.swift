//
//  SearchRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol SearchUserViewProtocol: AnyObject {
    
    func setLoadingView()
    func removeLoadingView()
    func removeMessageSubview()
    
    func success()
    func failure(error: String?)
}

protocol SearchUserViewPresenterProtocol: AnyObject {
    
    var user: User? { get set }
    var searchedUser: String? { get set }
    
    init(view: SearchUserViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func getUser()
}

class SearchUserPresenter: SearchUserViewPresenterProtocol {
    
    var searchedUser: String?
    var user: User?
    
    private weak var view: SearchUserViewProtocol?
    
    private let networkService: NetworkServiceProtocol!
    private var router: RouterProtocol?
    
    required init(
        view: SearchUserViewProtocol,
        networkService: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func getUser() {
        view?.removeMessageSubview()
        view?.setLoadingView()
        
        networkService.getUser(username: searchedUser ?? .empty) { result in
            DispatchQueue.main.async { [weak self] in
                self?.view?.removeLoadingView()
                
                switch result {
                    case .success(let requsetResult):
                        guard let result = requsetResult else {
                            self?.handleFailure()
                            return
                        }
                    
                        switch result.status {
                        case .success:
                            guard let resultUser = requsetResult?.result?[0] else {
                                self?.view?.failure(error: "Ошибка получения пользователя")
                                return
                            }
                            
                            self?.handleSuccess(resultUser)
                        case .failure:
                            self?.handleFailure()
                    }
                case .failure:
                    self?.handleFailure()
                }
            }
        } 
    }
    
    private func handleSuccess(_ resultUser: User) {
        user = resultUser
        
        view?.success()
    }
    
    private func handleFailure() {
        user = nil
        
        view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
    }
}
