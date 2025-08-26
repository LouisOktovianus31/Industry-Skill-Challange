//
//  AddCalendarSectionView.swift
//  Coco
//
//  Created by Arin Juan Sari on 25/08/25.
//

import UIKit

final class AddCalendarSectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = createImageView()
    private lazy var labelView: UILabel = createLabelView()
    var onTap: (() -> Void)?
}

// MARK: Private
private extension AddCalendarSectionView {
    func setupView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, labelView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
        
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = Token.additionalColorsLine.cgColor
        clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    func createImageView() -> UIImageView {
        let imageView = UIImageView(image: CocoIcon.icAddCalendarIcon.image)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    func createLabelView() -> UILabel {
        let textLabel = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .regular),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        textLabel.text = "Add calendar"
        
        return textLabel
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
