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

protocol ContestsViewPresenterProtocol: ConnectionMonitorProtocol {
    
    var contests: [Contest]? { get }
    var isFiltredByGym: Bool! { get }
    
    init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func requestContests()
    func searchContest(by text: String)
    func filterByGym()
    func showContestDetail(contest: Contest?, selectedIndex: Int?)
}

class ContestsPresenter: ContestsViewPresenterProtocol {
    
    var contests: [Contest]?
    var isFiltredByGym: Bool!
    
    private weak var view: ContestsViewProtocol?
    private var router: RouterProtocol?
    private let networkService: NetworkServiceProtocol!
    
    private var notFiltredContests: [Contest]?
    
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
    
    func requestContests() {
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
    
    func searchContest(by text: String) {
        let lowerSearchText = text.lowercased()
        
        contests = text.isEmpty
            ? notFiltredContests
            : notFiltredContests?.filter { $0.name.lowercased().contains(lowerSearchText) }
    }
    
    func filterByGym() {
        isFiltredByGym = !isFiltredByGym
        requestContests()
    }
    
    func showContestDetail(contest: Contest?, selectedIndex: Int?) {
        router?.showContestDetail(contest: contest, selectedIndex: selectedIndex)
    }
    
    func connectionSatisfied() {
        if contests == nil {
            requestContests()
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
        notFiltredContests = resultData
        
        if isFiltredByGym {
            contests?.reverse()
            notFiltredContests?.reverse()
        }
        
        view?.success()
    }
    
    private func handleFailure() {
        if contests == nil {
            view?.failure(error: "Что-то не так с Code forces. Мы уже работаем над этим.")
        } else {
            view?.failure(error: "Не удалось получить список соревнований.")
        }
    }
}
