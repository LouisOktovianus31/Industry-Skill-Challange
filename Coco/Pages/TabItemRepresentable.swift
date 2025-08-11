//
//  TabItemRepresentable.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import UIKit

protocol TabItemRepresentable {
    var tabTitle: String { get }
    var defaultTabIcon: UIImage? { get }
    var selectedTabIcon: UIImage? { get }
    
    /// Returns the root view controller (usually wrapped in a navigation controller)
    func makeRootViewController() -> UIViewController
}
