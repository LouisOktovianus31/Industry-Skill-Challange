//
//  ProfileTabItem.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import UIKit

struct ProfileTabItem: TabItemRepresentable {
    var tabTitle: String { "Profile" }
    var defaultTabIcon: UIImage? { CocoIcon.icTabIconProfile.image }
    var selectedTabIcon: UIImage? { CocoIcon.icTabIconProfileFill.image }

    func makeRootViewController() -> UIViewController {
        let vm: ProfileViewModel = ProfileViewModel()
        let vc: ProfileViewController = ProfileViewController(viewModel: vm)
        return vc
    }
}
