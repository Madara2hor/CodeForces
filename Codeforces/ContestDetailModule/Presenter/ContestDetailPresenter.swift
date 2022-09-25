//
//  ContestDetailPresenter.swift
//  Codeforces
//
//  Created by Madara2hor on 10.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol ContestDetailViewProtocol: AnyObject {
    
    func updateContest()
}

protocol ContestDetailViewPresenterProtocol: AnyObject {
    
    var contestName: String? { get }
    var contestInfo: [String] { get }
    
    init(view: ContestDetailViewProtocol, router: RouterProtocol, contest: Contest?)
    
    func requestContest()
}

class ContestDetailPresenter: ContestDetailViewPresenterProtocol {
    
    var contestName: String?
    var contestInfo: [String] = []
    
    private weak var view: ContestDetailViewProtocol?
    private var router: RouterProtocol?
    private var contest: Contest?
    
    required init(view: ContestDetailViewProtocol, router: RouterProtocol, contest: Contest?) {
        self.view = view
        self.router = router
        self.contest = contest
        
        makeContestInfo()
    }
    
    func requestContest() {
        view?.updateContest()
    }
    
    private func makeContestInfo() {
        contestName = contest?.name
        
        if let type = contest?.type.rawValue {
            contestInfo.append("Система оценки: \(type)")
        }
        if let phase = contest?.phase.localizedValue {
            contestInfo.append("Этап соревнований: \(phase)")
        }
        if let duration = contest?.durationSeconds {
            contestInfo.append("Продолжительность: \(String(describing: duration).durationFromSeconds)")
        }
        if let startTime = contest?.startTimeSeconds {
            contestInfo.append("Начало соревнования: \(String(describing: startTime).date)")
        }
        if let prepared = contest?.preparedBy {
            contestInfo.append("Содатель: \(prepared)")
        }
        if let website = contest?.websiteUrl {
            contestInfo.append("Сайт: \(website)")
        }
        if let description = contest?.description {
            contestInfo.append("Описание: \(description)")
        }
        if let difficulty = contest?.difficulty {
            contestInfo.append("Сложность: \(difficulty)")
        }
        if let kind = contest?.kind {
            contestInfo.append("Тип соревнования: \(kind)")
        }
        if let region = contest?.icpcRegion {
            contestInfo.append("Регион: \(region)")
        }
        if let country = contest?.country {
            contestInfo.append("Страна: \(country)")
        }
        if let city = contest?.city {
            contestInfo.append("Город: \(city)")
        }
        if let season = contest?.season {
            contestInfo.append("Сезон: \(season)")
        }
    }
}
