//
//  UIView+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

extension UIView {
    func layout(using builderBlock: (ConstraintBuilder) -> Void) {
        let builder: ConstraintBuilder = ConstraintBuilder(view: self)
        builderBlock(builder)
        builder.activate()
    }
    
    func addSubviewAndLayout(
        _ subview: UIView,
        insets: UIEdgeInsets = .zero
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

        subview.layout {
            $0.top(to: topAnchor, relation: .equal, constant: insets.top)
              .leading(to: leadingAnchor, relation: .equal, constant: insets.left)
              .trailing(to: trailingAnchor, relation: .equal, constant: -insets.right)
              .bottom(to: bottomAnchor, relation: .equal, constant: -insets.bottom)
        }
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
