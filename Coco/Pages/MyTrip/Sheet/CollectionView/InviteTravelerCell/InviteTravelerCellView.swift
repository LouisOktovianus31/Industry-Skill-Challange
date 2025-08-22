//
//  InviteTravelerCellView.swift
//  Coco
//
//  Created by Arin Juan Sari on 20/08/25.
//

import UIKit

final class InviteTravelerCellView: UICollectionViewCell {
    weak var delegate: InviteTravelerCellViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(dataModel: InviteTravelerCellDataModel, index: Int) {
        self.index = index
        textView.text = dataModel.email
    }
    
    private lazy var textView: UILabel = createTextView()
    private lazy var iconView: UIImageView = createIconView()
    private lazy var cardEmailView: UIStackView = createCardEmailView()
    private var index: Int = 0
}

protocol InviteTravelerCellViewDelegate: AnyObject {
    func didTapOnRemoveButton(at index: Int)
}

private extension InviteTravelerCellView {
    func setupView() {
        let stackView = UIStackView(arrangedSubviews: [cardEmailView])
        
        stackView.axis = .vertical
        stackView.spacing = 0
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func createTextView() -> UILabel {
        return UILabel(
            font: .jakartaSans(forTextStyle: .caption1, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
    }
    
    func createIconView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "xmark"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }
    
    @objc func imageTapped() {
        delegate?.didTapOnRemoveButton(at: index)
    }
    
    func createCardEmailView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [textView, iconView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.backgroundColor = Token.mainColorSecondary
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 12, right: 12)
        
        return stackView
    }
}
