//
//  Router.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import UIKit

protocol RouterMain {
    var tabBarController: UITabBarController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialTabBarController()
    func showUserDetail(user: User?, selectedIndex: Int?)
    func showContestDetail(contest: Contest?, selectedIndex: Int?)
}

class Router: RouterProtocol {

    var moduleBuilder: ModuleBuilderProtocol?
    var tabBarController: UITabBarController?
    
    init(tabBarController: UITabBarController, moduleBuilder: ModuleBuilderProtocol) {
        self.tabBarController = tabBarController
        self.moduleBuilder = moduleBuilder
    }
    
    func initialTabBarController() {
        if let tabBarController = tabBarController {
            guard let notificationNavigationController = moduleBuilder?.createTopUsersModule(router: self) else { return }
            guard let contestsNavigationController = moduleBuilder?.createContestsModule(router: self) else { return }
            guard let searchNavigationController = moduleBuilder?.createSearchModule(router: self) else { return }
            
            tabBarController.tabBar.tintColor = UIColor.buttonColor
            tabBarController.viewControllers = [contestsNavigationController,
                                                searchNavigationController,
                                                notificationNavigationController]
        }
    }
    
    func showUserDetail(user: User?, selectedIndex: Int?) {
        if selectedIndex == nil { return }
        if let tabBarPage = tabBarController?.viewControllers?[selectedIndex!] {
            let viewController = tabBarPage as? UINavigationController
            
            guard let navigationController = viewController else { return }
            guard let detailViewController = moduleBuilder?.createUserDetailModule(user: user, router: self) else { return }
            
            navigationController.present(detailViewController, animated: true)
        }
    }
    
    func showContestDetail(contest: Contest?, selectedIndex: Int?) {
        if selectedIndex == nil { return }
        if let tabBarPage = tabBarController?.viewControllers?[selectedIndex!] {
            let viewController = tabBarPage as? UINavigationController
            
            guard let navigationController = viewController else { return }
            guard let detailViewController = moduleBuilder?.createContestDetailModule(contest: contest, router: self) else { return }
            
            navigationController.present(detailViewController, animated: true)
        }
    }
    
}
