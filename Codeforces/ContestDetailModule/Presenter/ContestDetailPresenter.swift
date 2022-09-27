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
    var contestInfo: [InfoViewModel] { get }
    
    init(view: ContestDetailViewProtocol, router: RouterProtocol, contest: Contest?)
    
    func requestContest()
}

class ContestDetailPresenter: ContestDetailViewPresenterProtocol {
    
    var contestName: String?
    var contestInfo: [InfoViewModel] = []
    
    private weak var view: ContestDetailViewProtocol!
    private var router: RouterProtocol!
    private var contest: Contest?
    
    required init(view: ContestDetailViewProtocol, router: RouterProtocol, contest: Contest?) {
        self.view = view
        self.router = router
        self.contest = contest
        
        makeContestInfo()
    }
    
    func requestContest() {
        view.updateContest()
    }
    
    private func makeContestInfo() {
        contestName = contest?.name
        
        if let startTime = contest?.startTimeSeconds {
            contestInfo.append(InfoViewModel(
                title: "Начало соревнования",
                info: Double(startTime).date
            ))
        }
        if let duration = contest?.durationSeconds {
            contestInfo.append(InfoViewModel(
                title: "Длительность",
                info: duration.durationFromSeconds
            ))
        }
        if let beforeStart = contest?.relativeTimeSeconds {
            if beforeStart > .zero {
                contestInfo.append(InfoViewModel(
                    title: "Идет",
                    info: beforeStart.durationFromSeconds
                ))
            } else {
                contestInfo.append(InfoViewModel(
                    title: "До начала",
                    info: (-beforeStart).durationFromSeconds
                ))
            }
        }
        if let prepared = contest?.preparedBy {
            contestInfo.append(InfoViewModel(
                title: "Содатель",
                info: prepared
            ))
        }
        if let website = contest?.websiteUrl {
            contestInfo.append(InfoViewModel(
                title: "Сайт",
                info: website
            ))
        }
        if let description = contest?.description {
            contestInfo.append(InfoViewModel(
                title: "Описание",
                info: description
            ))
        }
        if let difficulty = contest?.difficulty {
            contestInfo.append(InfoViewModel(
                title: "Сложность",
                info: "\(difficulty)"
            ))
        }
        if let kind = contest?.kind {
            contestInfo.append(InfoViewModel(
                title: "Тип соревнования",
                info: kind
            ))
        }
        if let type = contest?.type.rawValue {
            contestInfo.append(InfoViewModel(
                title: "Система оценки",
                info: type
            ))
        }
        if let region = contest?.icpcRegion {
            contestInfo.append(InfoViewModel(
                title: "Регион",
                info: region
            ))
        }
        if let country = contest?.country {
            contestInfo.append(InfoViewModel(
                title: "Страна",
                info: country
            ))
        }
        if let city = contest?.city {
            contestInfo.append(InfoViewModel(
                title: "Город",
                info: city
            ))
        }
        if let season = contest?.season {
            contestInfo.append(InfoViewModel(
                title: "Сезон",
                info: season
            ))
        }
    }
}
