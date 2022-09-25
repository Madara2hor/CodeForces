//
//  ContestsPresenter.swift
//  Codeforces
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

protocol ContestsViewPresenterProtocol: ConnectionServiceProtocol {
    
    var contestsSections: [SectionViewModel] { get }
    var contests: [Contest]? { get }
    var isFiltredByGym: Bool! { get }
    
    init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func requestContests()
    func searchContest(by text: String)
    func filterByGym()
    func showContestDetail(contest: Contest?, selectedIndex: Int?)
}

class ContestsPresenter: ContestsViewPresenterProtocol {
    
    var contestsSections: [SectionViewModel] = []
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
                        self?.handleFailure(with: "Произошла непредвиденная ошибка.")
                        return
                    }
                    
                    switch requsetResult.status {
                    case .success:
                        guard
                            let resultData = requsetResult.result,
                            resultData.isEmpty == false
                        else {
                            self?.view?.failure(error: "Соревнований нет")
                            return
                        }
                        
                        self?.handleSuccess(resultData)
                    case .failure:
                        self?.handleFailure(with: "Что-то не так с Code forces. Мы уже работаем над этим.")
                    }
                case .failure:
                    self?.handleFailure(with: "Произошла непредвиденная ошибка.")
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
        handleFailure(with: "Потеряно интернет соединение.")
    }
    
    private func getPahseTitle(_ phase: ContestPhase) -> String {
        switch phase {
        case .coding:
            return "Текущие события"
        case .before:
            return "Предстоящие события"
        case .pendingSystemTest:
            return "Ожидается тестирование"
        case .systemTest:
            return "Тестирование"
        case .finished:
            return "Завершенные события"
        }
    }
    
    private func setupSections(for contests: [Contest]) {
        ContestPhase.allCases.forEach {
            switch $0 {
            case .coding:
                appendSectionIfNeeded(for: contests, phase: .coding)
            case .before:
                appendSectionIfNeeded(for: contests,phase: .before)
            case .systemTest:
                appendSectionIfNeeded(for: contests,phase: .systemTest)
            case .pendingSystemTest:
                appendSectionIfNeeded(for: contests,phase: .pendingSystemTest)
            case .finished:
                appendSectionIfNeeded(for: contests,phase: .finished)
            }
        }
    }
    
    private func appendSectionIfNeeded(for contests: [Contest], phase: ContestPhase) {
        let models = contests.filter({ $0.phase == phase })
        
        if models.isEmpty == false {
            contestsSections.append(
                SectionViewModel(
                    title: getPahseTitle(phase),
                    models: models
                )
            )
        }
    }
    
    private func handleSuccess(_ contestsData: [Contest]) {
        contests = contestsData
        notFiltredContests = contestsData
        
        if isFiltredByGym {
            contests?.reverse()
            notFiltredContests?.reverse()
        }
        
        setupSections(for: contestsData)
        
        view?.success()
    }
    
    private func handleFailure(with message: String) {
        contests = nil
        view?.failure(error: message)
    }
}

struct SectionViewModel {
    
    let title: String
    let models: [Contest]
}
