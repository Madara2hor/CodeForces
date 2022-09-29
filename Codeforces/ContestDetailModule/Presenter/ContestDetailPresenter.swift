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
        
        contestInfo = contest?.getInfoModel() ?? []
    }
}
