//
//  HomeRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol ContestsViewProtocol: class {
    func setLoadingView()
    func removeLoadingView()
    func removeMessageSubview()
    
    func success()
    func failure(error: String?)
}

protocol ContestsViewPresenterProtocol: FilterContestsProtocol, ConnectionMonitorProtocol {
    var contests: [Contest]? { get set }
    var gym: Bool! { get set }
    
    init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func getContests()
    func showContestDetail(contest: Contest?, selectedIndex: Int?)
}

protocol FilterContestsProtocol: class {
    var filtredContests: [Contest]? { get set }
    
    func sortContests()
}

class ContestsPresenter: ContestsViewPresenterProtocol {
    
    weak var view: ContestsViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    
    var contests: [Contest]?
    var filtredContests: [Contest]?
    var gym: Bool!
    
    required init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.gym = false
    }
    
    func getContests() {
        DispatchQueue.main.async {
            self.view?.removeMessageSubview()
            self.view?.setLoadingView()
        }
        
        networkService.getContests(gym: gym) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.removeLoadingView()
                
                switch result {
                case .success(let requsetResult):
                    switch requsetResult?.status {
                        case .success:
                            guard let resultData = requsetResult?.result, !resultData.isEmpty else {
                                self.view?.failure(error: "Соревнований нет...")
                                return
                            }
                            
                            self.contests = resultData
                            self.filtredContests = resultData
                            
                            if self.gym {
                                self.contests?.reverse()
                                self.filtredContests?.reverse()
                            }
                            
                            self.view?.success()
                        case .failure:
                            if self.contests == nil {
                                self.view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
                            }
                        case .none:
                            break
                    }
                case .failure:
                    if self.contests == nil {
                        self.view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
                    }
                }
            }
        } 
    }
    
    func sortContests() { }
    
    func showContestDetail(contest: Contest?, selectedIndex: Int?) {
        router?.showContestDetail(contest: contest, selectedIndex: selectedIndex)
    }
    
    func connectionSatisfied() {
        if self.contests == nil {
            self.getContests()
        }
    }
    
    func connectionUnsatisfied() {
        if self.contests == nil {
            DispatchQueue.main.async {
                self.view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
            }
        }
    }
    
}
