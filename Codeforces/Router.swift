//
//  Router.swift
//  Codeforces
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
        guard
            let tabBarController = tabBarController,
            let notificationNavigationController = moduleBuilder?.createTopUsersModule(router: self),
            let contestsNavigationController = moduleBuilder?.createContestsModule(router: self),
            let searchNavigationController = moduleBuilder?.createSearchModule(router: self)
        else {
            return
        }
        
        tabBarController.tabBar.tintColor = .label
        tabBarController.viewControllers = [
            contestsNavigationController,
            searchNavigationController,
            notificationNavigationController
        ]
    }
    
    func showUserDetail(user: User?, selectedIndex: Int?) {
        guard
            let navigationController = getNavigationController(for: selectedIndex),
            let detailViewController = moduleBuilder?.createUserDetailModule(user: user, router: self)
        else {
            return
        }
        
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showContestDetail(contest: Contest?, selectedIndex: Int?) {
        guard
            let navigationController = getNavigationController(for: selectedIndex),
            let detailViewController = moduleBuilder?.createContestDetailModule(contest: contest, router: self)
        else {
            return
        }
        
        navigationController.present(detailViewController, animated: true)
    }
    
    private func getNavigationController(for selectedIndex: Int?) -> UINavigationController? {
        guard
            let selectedIndex = selectedIndex,
            let tabBarPage = tabBarController?.viewControllers?[selectedIndex],
            let navigationController = tabBarPage as? UINavigationController
        else {
            return nil
        }
        
        return navigationController
    }
}
