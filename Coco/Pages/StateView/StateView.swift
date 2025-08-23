//
//  StateView.swift
//  Coco
//
//  Created by Arin Juan Sari on 22/08/25.
//

import UIKit

final class StateView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: StateViewData) {
        iconView.image = data.image
        labelView.text = data.message
        loadingView.isHidden = !data.isLoading
        iconView.isHidden = data.image == nil
    }
    
    private lazy var iconView: UIImageView = createIconView()
    private lazy var labelView: UILabel = createLabelView()
    private lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
}

private extension StateView {
    func setupViews() {
        backgroundColor = Token.additionalColorsWhite
        
        let stackView = UIStackView(arrangedSubviews: [
            iconView,
            loadingView,
            labelView,
        ])
        
        loadingView.startAnimating()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
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
