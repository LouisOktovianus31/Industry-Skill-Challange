//
//  ConstraintBuilder.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

enum ConstraintRelation {
    case equal
    case greaterThanOrEqual
    case lessThanOrEqual
}

final class ConstraintBuilder {
    private let view: UIView
    private var constraints: [NSLayoutConstraint] = []

    init(view: UIView) {
        self.view = view
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult
    func top(
        to anchor: NSLayoutYAxisAnchor,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.topAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }
    
    @discardableResult
    func edges(
        to view: UIView,
        constant: CGFloat = 0
    ) -> Self {
        view.translatesAutoresizingMaskIntoConstraints = false
        applyConstraint(from: view.topAnchor, to: view.topAnchor, relation: .equal, constant: constant)
        applyConstraint(from: view.leadingAnchor, to: view.leadingAnchor, relation: .equal, constant: constant)
        applyConstraint(from: view.trailingAnchor, to: view.trailingAnchor, relation: .equal, constant: -constant)
        applyConstraint(from: view.bottomAnchor, to: view.bottomAnchor, relation: .equal, constant: -constant)
        return self
    }

    @discardableResult
    func bottom(
        to anchor: NSLayoutYAxisAnchor,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.bottomAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }

    @discardableResult
    func leading(
        to anchor: NSLayoutXAxisAnchor,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.leadingAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }

    @discardableResult
    func trailing(
        to anchor: NSLayoutXAxisAnchor,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.trailingAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }
    
    @discardableResult
    func widthAnchor(
        to anchor: NSLayoutDimension,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.widthAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat) -> Self {
        constraints.append(view.widthAnchor.constraint(equalToConstant: constant))
        return self
    }

    @discardableResult
    func height(_ constant: CGFloat) -> Self {
        constraints.append(view.heightAnchor.constraint(equalToConstant: constant))
        return self
    }
    
    @discardableResult
    func size(_ constant: CGFloat) -> Self {
        constraints.append(view.heightAnchor.constraint(equalToConstant: constant))
        constraints.append(view.widthAnchor.constraint(equalToConstant: constant))
        return self
    }

    @discardableResult
    func centerX(
        to anchor: NSLayoutXAxisAnchor,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.centerXAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }

    @discardableResult
    func centerY(
        to anchor: NSLayoutYAxisAnchor,
        relation: ConstraintRelation = .equal,
        constant: CGFloat = 0
    ) -> Self {
        applyConstraint(from: view.centerYAnchor, to: anchor, relation: relation, constant: constant)
        return self
    }

    func activate() {
        NSLayoutConstraint.activate(constraints)
    }
}

private extension ConstraintBuilder {
    @discardableResult
    func applyConstraint<Anchor: AnyObject>(
        from fromAnchor: NSLayoutAnchor<Anchor>,
        to toAnchor: NSLayoutAnchor<Anchor>,
        relation: ConstraintRelation,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = fromAnchor.constraint(equalTo: toAnchor, constant: constant)
        case .greaterThanOrEqual:
            constraint = fromAnchor.constraint(greaterThanOrEqualTo: toAnchor, constant: constant)
        case .lessThanOrEqual:
            constraint = fromAnchor.constraint(lessThanOrEqualTo: toAnchor, constant: constant)
        }
        constraints.append(constraint)
        return constraint
    }
}
