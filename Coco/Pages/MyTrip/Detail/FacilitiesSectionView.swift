//
//  FacilitiesSectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 18/08/25.
//

import UIKit

final class FacilitiesSectionView: UIView {
    init(title: String, items: [String]) {
        super.init(frame: .zero)
        build(title: title, items: items)
    }
    required init?(coder: NSCoder) { fatalError() }

    private func build(title: String, items: [String]) {
        let titleLabel = UILabel(
            font: .jakartaSans(forTextStyle: .headline, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        titleLabel.text = title

        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.spacing = 12

        var i = 0
        while i < items.count {
            let h = UIStackView()
            h.axis = .horizontal
            h.spacing = 24
            h.distribution = .fillEqually

            h.addArrangedSubview(facilityRow(items[i]))
            if i + 1 < items.count {
                h.addArrangedSubview(facilityRow(items[i + 1]))
            } else {
                h.addArrangedSubview(UIView())
            }
            vstack.addArrangedSubview(h)
            i += 2
        }

        addSubviews([titleLabel, vstack])
        titleLabel.layout {
            $0.leading(to: leadingAnchor).top(to: topAnchor).trailing(to: trailingAnchor)
        }
        vstack.layout {
            $0.leading(to: leadingAnchor).top(to: titleLabel.bottomAnchor, constant: 12)
                .trailing(to: trailingAnchor).bottom(to: bottomAnchor)
        }
    }

    private func facilityRow(_ text: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center

        let icon = UIImageView(image: CocoIcon.icCheckMarkFill.image)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = Token.mainColorPrimary
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        icon.layout { $0.size(18) }

        let label = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .regular),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 0
        )
        label.text = text

        row.addArrangedSubview(icon)
        row.addArrangedSubview(label)
        return row
    }
}
