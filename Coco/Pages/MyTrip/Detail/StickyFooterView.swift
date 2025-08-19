//
//  StickyFooterView.swift
//  Coco
//
//  Created by Grachia Uliari on 18/08/25.
//

import UIKit

final class StickyFooterView: UIView {
    let button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Token.additionalColorsWhite
        build()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func build() {
        let sep = UIView()
        sep.backgroundColor = Token.additionalColorsLine

        button.setTitle("Invite traveler to space", for: .normal)
        button.setTitleColor(Token.additionalColorsWhite, for: .normal)
        button.backgroundColor = Token.mainColorPrimary
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .jakartaSans(forTextStyle: .body, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 14, right: 16)

        addSubviews([sep, button])
        sep.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sep.topAnchor.constraint(equalTo: topAnchor),
            sep.leadingAnchor.constraint(equalTo: leadingAnchor),
            sep.trailingAnchor.constraint(equalTo: trailingAnchor),
            sep.heightAnchor.constraint(equalToConstant: 1),

            button.topAnchor.constraint(equalTo: sep.bottomAnchor, constant: 12),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
        ])
    }
}
