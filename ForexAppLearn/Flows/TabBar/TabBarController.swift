//
//  TabBarController.swift
//  Quotex
//
//  Created by Yaşar Ergin on 13.10.2022.
//

import UIKit

final class MainTabBar: UITabBarController {
    let tradeController = TradeScreenViewController()
    let leadersController = LeaderboardScreenViewController()
    let settingsController = SettingsScreenViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupAppearance() {
        tabBar.backgroundColor = UIColor(hex: "172331", alpha: 0.94)
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.5)
        tabBar.tintColor = .white
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = UIColor(hex: "172331", alpha: 0.94)
        UITabBar.appearance().tintColor = UIColor(hex: "FF9933", alpha: 0.94)
    }
    
    private func setupTabs() {
        tradeController.tabBarItem = UITabBarItem(
            title: R.string.localizable.tabBarTradeTitle(),
            image: R.image.tradeBarIcon(),
            tag: 0
        )
    
        
        let leadersControllerNavigationController = UINavigationController(rootViewController: leadersController)
        leadersControllerNavigationController.tabBarItem = UITabBarItem(
            title: R.string.localizable.tabBarLeaderboardTitle(),
            image: R.image.leaderboardTabICon(),
            tag: 2
        )
        
        settingsController.tabBarItem = UITabBarItem(
            title: R.string.localizable.tabBarSettingsTitle(),
            image: R.image.settingsBarIcon(),
            tag: 3
        )
        
      
        viewControllers = [
        tradeController, leadersControllerNavigationController, settingsController
        ]
    }
}
