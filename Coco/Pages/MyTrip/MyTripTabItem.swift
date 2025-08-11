//
//  MyTripTabItem.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import UIKit

struct MyTripTabItem: TabItemRepresentable {
    var tabTitle: String { "MyTrip" }
    var defaultTabIcon: UIImage? { CocoIcon.icTabIconTrip.image }
    var selectedTabIcon: UIImage? { CocoIcon.icTabIconTripFill.image }

    func makeRootViewController() -> UIViewController {
        let viewModel: MyTripViewModel = MyTripViewModel()
        let vc: MyTripViewController = MyTripViewController(viewModel: viewModel)
        return vc
    }
}
