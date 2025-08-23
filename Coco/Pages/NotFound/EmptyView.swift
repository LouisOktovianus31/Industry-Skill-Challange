//
//  EmptyView.swift
//  Coco
//
//  Created by Arin Juan Sari on 22/08/25.
//

import UIKit

final class EmptyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView: UIImageView = createIconView()
    private lazy var labelView: UILabel = createLabelView()
}

private extension EmptyView {
    func setupViews() {
        backgroundColor = Token.additionalColorsWhite
        
        let stackView = UIStackView(arrangedSubviews: [
            iconView,
            labelView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func createIconView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "emptyIcon"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    func createLabelView() -> UILabel {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .body, weight: .semibold),
            textColor: Token.grayscale80,
            numberOfLines: 2
        )
        label.text = "Data is empty"
        
        return label
    }
}
