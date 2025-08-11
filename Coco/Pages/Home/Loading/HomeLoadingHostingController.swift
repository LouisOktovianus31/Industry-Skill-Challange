//
//  HomeLoadingHostingController.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import UIKit
import SwiftUI

final class HomeLoadingHostingController: UIHostingController<HomeLoadingView> {
    let state: HomeLoadingState

    init(state: HomeLoadingState) {
        self.state = state
        super.init(rootView: HomeLoadingView(state: state))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
