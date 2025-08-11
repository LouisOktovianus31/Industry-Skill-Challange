//
//  BaseTabBarViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import UIKit

final class BaseTabBarViewController: UITabBarController {
    weak var baseCoordinator: AppCoordinator?
    
    var currentActiveNavigationController: UINavigationController? {
        navigationControllers[safe: selectedIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabs()
        
        previousSelectedIndex = selectedIndex
    }
    
    private let tabBarItemDatas: [TabItemRepresentable] = [
        HomeTabItem(),
        MyTripTabItem(),
        ProfileTabItem(),
    ]
    
    private lazy var navigationControllers: [UINavigationController] = []
    
    private var currentActiveTabBarDatas: TabItemRepresentable? {
        tabBarItemDatas[safe: selectedIndex]
    }
    
    private var previousSelectedIndex: Int = 0
}

extension BaseTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index: Int = viewControllers?.firstIndex(of: viewController),
              index != previousSelectedIndex else { return }
        
        previousSelectedIndex = index
        resetAllNavigationControllers(except: viewController)
    }
}

private extension BaseTabBarViewController {
    func setupTabs() {
        tabBarItemDatas.enumerated().forEach { (index, tabBarItem) in
            let navigationController: UINavigationController = UINavigationController(rootViewController: tabBarItem.makeRootViewController())
            navigationController.tabBarItem = UITabBarItem(
                title: tabBarItem.tabTitle,
                image: tabBarItem.defaultTabIcon,
                selectedImage: tabBarItem.selectedTabIcon
            )
            navigationController.tabBarItem.tag = index
            navigationControllers.append(navigationController)
        }
        
        viewControllers = navigationControllers
        tabBar.tintColor = Token.mainColorPrimary
        tabBar.backgroundColor = .white
    }
    
    func resetAllNavigationControllers(except selectedVC: UIViewController) {
        for vc in viewControllers ?? [] {
            guard let nav = vc as? UINavigationController else { continue }
            if nav != selectedVC {
                nav.popToRootViewController(animated: false)
            }
        }
    }
}
