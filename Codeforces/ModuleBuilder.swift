//
//  ModuleBuilder.swift
//  Twitter
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
        
        view.tabBarItem =  UITabBarItem(title: nil,
                                        image: UIImage(named: "outline_list.png"),
                                        tag: 0)
        view.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
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
        view.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "outline_search.png"),
                                       tag: 1)
        view.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
        let networkService = NetworkService()
        let presenter = SearchUserPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        loadView(view: view)
        
        let navigationController = createNavigationController(view: view, title: "Поиск пользователей")
        
        return navigationController
    }
    
    func createTopUsersModule(router: RouterProtocol) -> UINavigationController {
        let view = TopUsersViewContoller()
        view.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "outline_top.png"),
                                       tag: 2)
        view.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
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
        navigationController.navigationBar.barTintColor = UIColor.systemBackground
        
        return navigationController
    }
    
    func setPresenterToConnectionMonitor(presenter: ConnectionMonitorProtocol) {
        if InternetConnection.shared.presenters != nil {
            InternetConnection.shared.presenters?.append(presenter)
        } else {
            InternetConnection.shared.presenters = [presenter]
        }
    }
    
    func loadView(view: UIViewController) {
        view.loadView()
        view.viewDidLoad()
    }
}
