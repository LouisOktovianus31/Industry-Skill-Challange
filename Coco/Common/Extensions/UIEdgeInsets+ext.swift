//
//  UIEdgeInsets+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(edges: CGFloat) {
        self.init(top: edges, left: edges, bottom: edges, right: edges)
    }
}
