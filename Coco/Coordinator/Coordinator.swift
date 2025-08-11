//
//  Coordinator.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation
import UIKit

@objc protocol Coordinator: BaseCoordinatorProtocol {
    var children: [BaseCoordinatorProtocol] { get set }
    
    func childDidFinish(_ coordinator : BaseCoordinatorProtocol)
}

@objc  protocol BaseCoordinatorProtocol: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var navigationController : UINavigationController? { get set }
    
    func start()
}
