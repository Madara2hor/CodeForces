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
    func updateGymFilterButton(isFiltred: Bool)
    
    func success()
    func failure(error: String?)
}

protocol ContestsViewPresenterProtocol: ConnectionMonitorProtocol {
        
    init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func getContests()
    func serachContest(by text: String)
    func getFiltredContests() -> [Contest]?
    func filterByGym()
    func showContestDetail(contest: Contest?, selectedIndex: Int?)
}

class ContestsPresenter: ContestsViewPresenterProtocol {
    
    private weak var view: ContestsViewProtocol?
    private var router: RouterProtocol?
    private let networkService: NetworkServiceProtocol!
    
    private var contests: [Contest]?
    private var filtredContests: [Contest]?
    private var isFiltredByGym: Bool!
    
    required init(
        view: ContestsViewProtocol,
        networkService: NetworkServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.router = router
        self.networkService = networkService
        isFiltredByGym = false
    }
    
    func getContests() {
        view?.removeMessageSubview()
        view?.setLoadingView()
        
        networkService.getContests(gym: isFiltredByGym) { result in
            DispatchQueue.main.async { [weak self] in
                self?.view?.removeLoadingView()
                
                switch result {
                case .success(let requsetResult):
                    guard let requsetResult = requsetResult else {
                        self?.handleFailure()
                        return
                    }
                    switch requsetResult.status {
                    case .success:
                        self?.handleSuccess(requsetResult.result)
                    case .failure:
                        self?.handleFailure()
                    }
                case .failure:
                    self?.handleFailure()
                }
            }
        } 
    }
    
    func serachContest(by text: String) {
        let lowerSearchText = text.lowercased()
        
        filtredContests = text.isEmpty
        ? contests
        : contests?.filter { contest -> Bool in
            return contest.name.lowercased().contains(lowerSearchText)
        }
    }
    
    func getFiltredContests() -> [Contest]? {
        return filtredContests
    }
    
    func filterByGym() {
        isFiltredByGym = !isFiltredByGym
        getContests()
    }
    
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
        } else {
            view?.failure(error: "Интернет куда-то пропал...")
        }
    }
    
    private func handleSuccess(_ result: [Contest]?) {
        guard
            let resultData = result,
            resultData.isEmpty == false
        else {
            view?.failure(error: "Соревнований нет")
            return
        }
        
        contests = resultData
        filtredContests = resultData
        
        if isFiltredByGym {
            contests?.reverse()
            filtredContests?.reverse()
        }
        
        view?.success()
    }
    
    private func handleFailure() {
        if contests == nil {
            view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
        } else {
            view?.failure(error: "Не удалось обновить список соревнований.")
        }
    }
}
