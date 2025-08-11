//
//  UIButton+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 07/07/25.
//

import Foundation
import UIKit

extension UIButton {
    static func textButton(
        title: String,
        color: UIColor = .systemBlue,
        font: UIFont = .jakartaSans(forTextStyle: .footnote, weight: .medium)
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = font
        return button
    }
}
