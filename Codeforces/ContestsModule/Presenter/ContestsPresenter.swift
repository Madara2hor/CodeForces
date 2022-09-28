//
//  ContestsPresenter.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct SectionViewModel {
    
    let title: String
    let models: [Contest]
}

protocol ContestsViewProtocol: AnyObject {
    
    func setLoadingView()
    func removeLoadingView()
    
    func success()
    func failure(error: String?)
}

protocol ContestsViewPresenterProtocol: ConnectionServiceProtocol {
    
    var contestsSections: [SectionViewModel] { get }
    var isFiltredByGym: Bool { get }
    
    init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func requestContests()
    func searchedContestUpdated(with text: String)
    func filterByGymTapped()
    func showContestDetailTapped(contest: Contest?, selectedIndex: Int?)
}

class ContestsPresenter: ContestsViewPresenterProtocol {
    
    var contestsSections: [SectionViewModel] = []
    var isFiltredByGym: Bool
    
    private weak var view: ContestsViewProtocol!
    private var router: RouterProtocol!
    private let networkService: NetworkServiceProtocol!
    
    private var notFiltredSections: [SectionViewModel] = []
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
        view.setLoadingView()
        
        networkService.getContests(gym: isFiltredByGym) { result in
            self.view.removeLoadingView()
            
            switch result {
            case .success(let requsetResult):
                guard let requsetResult = requsetResult else {
                    self.handleFailure(with: "Произошла непредвиденная ошибка.")
                    return
                }
                
                switch requsetResult.status {
                case .success:
                    guard
                        let resultData = requsetResult.result,
                        resultData.isEmpty == false
                    else {
                        self.handleFailure(with: "Соревнований нет")
                        return
                    }
                    
                    self.handleSuccess(resultData)
                case .failure:
                    self.handleFailure(with: "Что-то не так с Code forces. Мы уже работаем над этим.")
                }
            case .failure:
                self.handleFailure(with: "Произошла непредвиденная ошибка.")
            }
        } 
    }
    
    func searchedContestUpdated(with text: String) {
        let lowerSearchText = text.lowercased()
        
        contestsSections = text.isEmpty
            ? notFiltredSections
            : notFiltredSections.compactMap {
                let models = $0.models.filter { contest in
                    contest.name.lowercased().contains(lowerSearchText)
                }
                
                if models.isEmpty {
                    return nil
                }
                
                return SectionViewModel(title: $0.title, models: models)
            }
    }
    
    func filterByGymTapped() {
        isFiltredByGym = !isFiltredByGym
        requestContests()
    }
    
    func showContestDetailTapped(contest: Contest?, selectedIndex: Int?) {
        router?.showContestDetail(contest: contest, selectedIndex: selectedIndex)
    }
    
    func connectionSatisfied() {
        if contestsSections.isEmpty {
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
        let sortedContests = contestsData.sorted(by: {
            ($0.relativeTimeSeconds ?? .zero) > ($1.relativeTimeSeconds ?? .zero)
        })
        
        setupSections(for: sortedContests)
        notFiltredSections = contestsSections
        
        view.success()
    }
    
    private func handleFailure(with message: String) {
        contestsSections.removeAll()
        view.failure(error: message)
    }
}
