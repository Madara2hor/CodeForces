//
//  ContestDetailPresenter.swift
//  Codeforces
//
//  Created by Madara2hor on 10.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

protocol ContestDetailViewProtocol: class {
    func setContest(contest: Contest?)
}

protocol ContestDetailViewPresenterProtocol: class {
    init(view: ContestDetailViewProtocol, router: RouterProtocol, contest: Contest?)
    func setContest()
}

class ContestDetailPresenter: ContestDetailViewPresenterProtocol {
    weak var view: ContestDetailViewProtocol?
    var router: RouterProtocol?
    var contest: Contest?
    
    required init(view: ContestDetailViewProtocol, router: RouterProtocol, contest: Contest?) {
        self.view = view
        self.router = router
        self.contest = contest
    }
    
    func setContest() {
        self.view?.setContest(contest: contest)
    }
}
