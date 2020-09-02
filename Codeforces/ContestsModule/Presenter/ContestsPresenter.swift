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
    func removeEmptySubview()
    
    func success()
    func failure(error: String?)
}

protocol ContestsViewPresenterProtocol: class {
    var contests: [Contest]? { get set }
    var gym: Bool! { get set }
    
    init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func getContests()
    func showContestDetail(contest: Contest?, selectedIndex: Int?)
}

class ContestsPresenter: ContestsViewPresenterProtocol {
    weak var view: ContestsViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    
    var contests: [Contest]?
    var gym: Bool!
    
    required init(view: ContestsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.gym = false
        
        getContests()
    }
    
    func getContests() {
        DispatchQueue.main.async {
            self.view?.removeEmptySubview()
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
                            self.contests = requsetResult?.result
                            if self.gym {
                                self.contests?.reverse()
                            }
                            self.view?.success()
                        case .failure:
                            self.contests = nil
                            self.view?.failure(error: requsetResult?.comment)
                        case .none:
                            break
                    }
                case .failure(let error):
                    self.view?.failure(error: error.localizedDescription)
                }
            }
        }
    }
    
    func showContestDetail(contest: Contest?, selectedIndex: Int?) {
        router?.showContestDetail(contest: contest, selectedIndex: selectedIndex)
    }
}
