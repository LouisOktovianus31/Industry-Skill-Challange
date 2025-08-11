//
//  HomeTabItem.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import SwiftUI
import UIKit

struct HomeTabItem: TabItemRepresentable {
    var tabTitle: String { "Home" }
    var defaultTabIcon: UIImage? { CocoIcon.icTabIconHome.image }
    var selectedTabIcon: UIImage? { CocoIcon.icTabIconHomeFill.image }

    func makeRootViewController() -> UIViewController {
        let viewModel: HomeViewModel = HomeViewModel()
        let viewController: HomeViewController = HomeViewController(viewModel: viewModel)
        
        return viewController
    }
    
    private let viewModel = HomeCollectionViewModel()
    
    private let vm = HomeLoadingState()
}
