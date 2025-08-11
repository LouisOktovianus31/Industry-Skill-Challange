//
//  AppCoordinator.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation
import UIKit

final class AppCoordinator {
    // Properties
    weak var parentCoordinator: Coordinator?
    weak var navigationController: UINavigationController?
    
    var children: [BaseCoordinatorProtocol] = []
    
    // Static shared instance
    static let shared: AppCoordinator = AppCoordinator()
    
    // Private initializer to prevent instantiation from outside
    private init() {}
}

extension AppCoordinator: Coordinator {
    func start() {
        guard let navigationController: UINavigationController else {
            assertionFailure("Navigation controller must be set before starting the coordinator.")
            return
        }
    }
    
    func setNavigationController(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func childDidFinish(_ coordinator : BaseCoordinatorProtocol){
        // Call this if a coordinator is done.
        for (index, child) in children.enumerated() {
            if child === coordinator {
                children.remove(at: index)
                break
            }
        }
    }
}
