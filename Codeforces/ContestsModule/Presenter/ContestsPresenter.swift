//
//  HomeRouter.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol ContestsViewProtocol: AnyObject {
    
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

protocol FilterContestsProtocol: AnyObject {
    
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
    
    required init(
        view: ContestsViewProtocol,
        networkService: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.router = router
        self.networkService = networkService
        gym = false
    }
    
    func getContests() {
        view?.removeMessageSubview()
        view?.setLoadingView()
        
        networkService.getContests(gym: gym) { result in
            DispatchQueue.main.async { [weak self] in
                self?.view?.removeLoadingView()
                
                switch result {
                case .success(let requsetResult):
                    switch requsetResult?.status {
                        case .success:
                            guard
                                let resultData = requsetResult?.result,
                                resultData.isEmpty == false
                            else {
                                self?.view?.failure(error: "Соревнований нет...")
                                return
                            }
                            
                            self?.contests = resultData
                            self?.filtredContests = resultData
                            
                            if self?.gym ?? false {
                                self?.contests?.reverse()
                                self?.filtredContests?.reverse()
                            }
                            
                            self?.view?.success()
                        case .failure:
                            if self?.contests == nil {
                                self?.view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
                            }
                        case .none:
                            break
                    }
                case .failure:
                    if self?.contests == nil {
                        self?.view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
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
        if contests == nil {
            getContests()
        }
    }
    
    func connectionUnsatisfied() {
        if contests == nil {
            view?.failure(error: "Произошла непредвиденная ошибка. Возможно проблемы с интернет соединением.")
        }
    }
}
