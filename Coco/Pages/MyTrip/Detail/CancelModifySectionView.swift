//
//  CancelModifySectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 18/08/25.
//

import UIKit

final class ActionSectionView: UIStackView {
    
    let cancelButton = UIButton(type: .system)
    let modifyButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func build() {
        axis = .horizontal
        spacing = 16
        distribution = .fillEqually
        
        // Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Token.alertsError, for: .normal)
        cancelButton.titleLabel?.font = .jakartaSans(forTextStyle: .body, weight: .semibold)
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Token.alertsError.cgColor
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        
        // Modify button
        modifyButton.setTitle("Modify", for: .normal)
        modifyButton.setTitleColor(.gray, for: .normal)
        modifyButton.titleLabel?.font = .jakartaSans(forTextStyle: .body, weight: .semibold)
        modifyButton.backgroundColor = Token.grayscale30
        modifyButton.layer.cornerRadius = 25
        modifyButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        
        addArrangedSubview(cancelButton)
        addArrangedSubview(modifyButton)
    }
}
