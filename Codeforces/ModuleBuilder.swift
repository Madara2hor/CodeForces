//
//  ModuleBuilder.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import UIKit

protocol ModuleBuilderProtocol {
    
    func createContestsModule(router: RouterProtocol) -> UINavigationController
    func createContestDetailModule(contest: Contest?, router: RouterProtocol) -> UIViewController
    func createSearchModule(router: RouterProtocol) -> UINavigationController
    func createTopUsersModule(router: RouterProtocol) -> UINavigationController
    func createUserDetailModule(user: User?, router: RouterProtocol) -> UIViewController
    func createNavigationController(view: UIViewController, title: String) -> UINavigationController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    func createContestsModule(router: RouterProtocol) -> UINavigationController {
        let view = ContestsViewController()
        
        view.tabBarItem =  UITabBarItem(
            title: "Соревнования",
            image: UIImage(named: "outline_list.png"),
            tag: .zero
        )
        
        let networkService = NetworkService()
        let presenter = ContestsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        loadView(view: view)
        
        setPresenterToConnectionMonitor(presenter: presenter)
        
        let navigationController = createNavigationController(view: view, title: "Соревнования")
        
        return navigationController
    }
    
    func createSearchModule(router: RouterProtocol) -> UINavigationController {
        let view = SearchUserViewController()
        view.tabBarItem = UITabBarItem(
            title: "Поиск",
            image: UIImage(named: "outline_search.png"),
            tag: .one
        )
        
        let networkService = NetworkService()
        let presenter = SearchUserPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        loadView(view: view)
        
        setPresenterToConnectionMonitor(presenter: presenter)
        
        let navigationController = createNavigationController(view: view, title: "Поиск пользователей")
        
        return navigationController
    }
    
    func createTopUsersModule(router: RouterProtocol) -> UINavigationController {
        let view = NewTopUsersViewController()
        view.tabBarItem = UITabBarItem(
            title: "Топ",
            image: UIImage(named: "outline_top.png"),
            tag: .two
        )
        
        let networkService = NetworkService()
        let presenter = TopUsersPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        loadView(view: view)
        
        setPresenterToConnectionMonitor(presenter: presenter)
        
        let navigationController = createNavigationController(view: view, title: "Топ пользователей")
        
        return navigationController
    }
    
    func createUserDetailModule(user: User?, router: RouterProtocol) -> UIViewController {
        let view = UserDetailViewController()
        
        let presenter = UserDetailPresenter(view: view, router: router, user: user)
        view.presenter = presenter
        
        return view
    }
    
    
    func createContestDetailModule(contest: Contest?, router: RouterProtocol) -> UIViewController {
        let view = ContestDetailViewController()
        
        let presenter = ContestDetailPresenter(view: view, router: router, contest: contest)
        view.presenter = presenter
        
        return view
    }
    
    func createNavigationController(view: UIViewController, title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.topItem?.title = title
        navigationController.navigationBar.barTintColor = .systemBackground
        
        return navigationController
    }
    
    func setPresenterToConnectionMonitor(presenter: ConnectionServiceProtocol) {
        if NetworkConnectionService.shared.presenters != nil {
            NetworkConnectionService.shared.presenters?.append(presenter)
        } else {
            NetworkConnectionService.shared.presenters = [presenter]
        }
    }
    
    func loadView(view: UIViewController) {
        view.loadViewIfNeeded()
    }
}
