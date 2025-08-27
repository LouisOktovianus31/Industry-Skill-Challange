//
//  ImportantNoticeSectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 18/08/25.
//


import UIKit

final class ImportantNoticeSectionView: UIStackView {
    
    private let icon = UIImageView(image: UIImage(systemName: "info.circle.fill"))
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func build() {
        axis = .vertical
        spacing = 8
        
        // Header (icon + title)
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        
        icon.tintColor = .systemRed
        icon.setContentHuggingPriority(.required, for: .horizontal)
        
        titleLabel.text = "Important Notice"
        titleLabel.font = .jakartaSans(forTextStyle: .body, weight: .medium)
        titleLabel.textColor = Token.alertsError
        
        headerStack.addArrangedSubview(icon)
        headerStack.addArrangedSubview(titleLabel)
        
        // Body text
        bodyLabel.text = "Please ensure that all traveler information is correct before proceeding. Modification requests are subject to availability and confirmation from the vendor."
        bodyLabel.font = .jakartaSans(forTextStyle: .footnote, weight: .regular)
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = Token.additionalColorsBlack
        
        addArrangedSubview(headerStack)
        addArrangedSubview(bodyLabel)
    }
}
