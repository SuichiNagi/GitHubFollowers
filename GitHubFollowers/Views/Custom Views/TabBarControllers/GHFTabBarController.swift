//
//  GHFTabBarController.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 7/3/24.
//

import UIKit

class GHFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    

//    func createNC(vc: UIViewController, title: String, tabBarSystemItem: UITabBarItem.SystemItem, tag: Int) -> UINavigationController {
//        let myVC = vc
//        myVC.title = title
//        myVC.tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: tag)
//    
//        return UINavigationController(rootViewController: myVC)
//    }
    
    func setTabBar() {
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor   = .systemBackground
        viewControllers                         = [createSearchNC(), createFavoritesNC()]
    }
        
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
            
        return UINavigationController(rootViewController: searchVC)
    }
        
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesListVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
            
        return UINavigationController(rootViewController: favoritesVC)
    }
}
