//
//  UILabel+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(
        font: UIFont,
        textColor: UIColor,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .natural
    ) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
}
