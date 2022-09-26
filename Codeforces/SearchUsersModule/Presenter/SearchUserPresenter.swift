//
//  SearchUserPresenter.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol SearchUserViewProtocol: AnyObject {
    
    func setLoadingView()
    func removeLoadingView()
    
    func success()
    func failure(error: String?)
}

protocol SearchUserViewPresenterProtocol: ConnectionServiceProtocol {
    
    var userHeaderModel: UserHeaderViewModel? { get }
    var userInfo: [String] { get }
    
    init(view: SearchUserViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func searchUser()
    func updateSearchedUser(_ username: String)
    func clearUser()
}

class SearchUserPresenter: SearchUserViewPresenterProtocol {
    
    var userHeaderModel: UserHeaderViewModel? = nil
    var userInfo: [String] = []
    
    private weak var view: SearchUserViewProtocol?
    
    private let networkService: NetworkServiceProtocol!
    private var router: RouterProtocol?
    
    private var searchedUsername: String?
    private var user: User?
    
    required init(
        view: SearchUserViewProtocol,
        networkService: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func updateSearchedUser(_ username: String) {
        searchedUsername = username
    }
    
    func searchUser() {
        guard let searchedUsername = searchedUsername else {
            return
        }
        
        view?.setLoadingView()
        
        networkService.getUser(username: searchedUsername) { result in
            DispatchQueue.main.async { [weak self] in
                self?.view?.removeLoadingView()
                
                switch result {
                    case .success(let requsetResult):
                        guard let result = requsetResult else {
                            self?.handleFailure(with: "Произошла непредвиденная ошибка.")
                            return
                        }
                    
                        switch result.status {
                        case .success:
                            guard let resultUser = requsetResult?.result?[.zero] else {
                                self?.handleFailure(with: "Не удалось получить информуцию о пользователе.")
                                return
                            }
                            
                            self?.handleSuccess(resultUser)
                        case .failure:
                            self?.handleFailure(with: "Что-то не так с Code forces. Мы уже работаем над этим.")
                    }
                case .failure:
                    self?.handleFailure(with: "Произошла непредвиденная ошибка.")
                }
            }
        } 
    }
    
    func clearUser() {
        user = nil
        searchedUsername = nil
        userHeaderModel = nil
        userInfo = []
    }
    
    func connectionSatisfied() {
        if user == nil && searchedUsername != nil {
            searchUser()
        }
    }
    
    func connectionUnsatisfied() {
        handleFailure(with: "Потеряно интернет соединение.")
    }
    
    private func makeUserInfo(for user: User) {
        userHeaderModel = UserHeaderViewModel(
            image: user.titlePhoto,
            username: user.handle,
            lastOnline: user.lastOnlineTimeSeconds
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
        userInfo.append("Друзей: \(user.friendOfCount)")
        
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
    
    private func handleSuccess(_ resultUser: User) {
        user = resultUser
        makeUserInfo(for: resultUser)
        
        view?.success()
    }
    
    private func handleFailure(with message: String) {
        user = nil
        view?.failure(error: message)
    }
}
