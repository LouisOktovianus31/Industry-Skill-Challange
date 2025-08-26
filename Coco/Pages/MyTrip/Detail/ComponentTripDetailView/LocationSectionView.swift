//
//  LocationSectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 22/08/25.
//

import UIKit

final class LocationSectionView: UIView {

    // MARK: Public API
    var onTap: (() -> Void)?
    func configure(text: String) {
        locationTextLabel.text = text
        isAccessibilityElement = true
        accessibilityLabel = "Location"
        accessibilityValue = text
        accessibilityTraits = .button
    }

    // MARK: UI
    private let iconView: UIImageView = {
        let iconview = UIImageView(image: CocoIcon.icPinPointBlue.image)
        iconview.contentMode = .scaleAspectFit
        iconview.setContentHuggingPriority(.required, for: .horizontal)
        iconview.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iconview
    }()

    private let locationTextLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .regular),
            textColor: Token.grayscale90,
            numberOfLines: 1
        )
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let chevronView: UIImageView = {
        let iconview = UIImageView(image: CocoIcon.icChevronRight.image)
        iconview.tintColor = Token.grayscale60
        iconview.contentMode = .scaleAspectFit
        iconview.setContentHuggingPriority(.required, for: .horizontal)
        iconview.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iconview
    }()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
private extension LocationSectionView {
    func build() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = Token.additionalColorsLine.cgColor
        backgroundColor = Token.additionalColorsWhite
        layout { $0.height(45) }

        addSubviews([iconView, locationTextLabel, chevronView])

        iconView.layout {
            $0.leading(to: leadingAnchor, constant: 12)
                .centerY(to: centerYAnchor)
                .size(22)
        }
        chevronView.layout {
            $0.trailing(to: trailingAnchor, constant: -12)
                .centerY(to: centerYAnchor)
                .size(22)
        }
        locationTextLabel.layout {
            $0.leading(to: iconView.trailingAnchor, constant: 10)
                .trailing(to: chevronView.leadingAnchor, constant: -10)
                .centerY(to: centerYAnchor)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc func didTap() {
        let originalColor = backgroundColor
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = UIColor.systemGray5
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = originalColor
            }
        }
        
        onTap?()
    }
}
