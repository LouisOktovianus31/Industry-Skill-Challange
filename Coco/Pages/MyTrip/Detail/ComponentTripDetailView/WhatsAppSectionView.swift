//
//  WhatsAppSectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 23/08/25.
//

import UIKit

final class WhatsAppSectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    var onTap: (() -> Void)?
        func configure(title: String = "Join the Trip WhatsApp Community") {
            textLabel.text = title
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: CocoIcon.whatsappIcon.image)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .regular),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        textLabel.text = "Join the trip community"
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textLabel
    }()
}

// MARK: Private
private extension WhatsAppSectionView {
    func build() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = Token.additionalColorsLine.cgColor
        backgroundColor = Token.additionalColorsWhite
        layout { $0.height(45) }
        
        addSubviews([imageView, textLabel])
        
        imageView.layout {
            $0.leading(to: leadingAnchor, constant: 12)
                .centerY(to: centerYAnchor)
                .size(22)
        }
        textLabel.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 10)
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
