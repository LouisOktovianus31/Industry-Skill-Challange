//
//  ProfileCoordinator.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation
import UIKit

final class ProfileCoordinator: BaseCoordinator {
    override func start() {
        super.start()
        // start flow
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        start(viewController: vc)
    }
}
