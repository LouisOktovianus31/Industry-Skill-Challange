//
//  HomeActivityCell.swift
//  Coco
//
//  Created by Jackie Leonardy on 04/07/25.
//

import Foundation
import UIKit

final class HomeActivityCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ dataModel: HomeActivityCellDataModel) {
        imageView.loadImage(from: dataModel.imageUrl)
        areaLabel.text = dataModel.area
        nameLabel.text = dataModel.name
        
        let attributedString = NSMutableAttributedString(
            string: dataModel.priceText,
            attributes: [
                .font : UIFont.jakartaSans(forTextStyle: .body, weight: .bold),
                .foregroundColor : Token.additionalColorsBlack
            ]
        )
        
        attributedString.append(
            NSAttributedString(
                string: "/Person",
                attributes: [
                    .font : UIFont.jakartaSans(forTextStyle: .callout, weight: .medium),
                    .foregroundColor : Token.additionalColorsBlack
                ]
            )
        )
        
        priceLabel.attributedText = attributedString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private lazy var imageView: UIImageView = createImageView()
    private lazy var areaView: UIView = createAreaView()
    private lazy var areaLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .callout, weight: .medium),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
    private lazy var nameLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .title3, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
    private lazy var priceLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
}

private extension HomeActivityCell {
    func setupView() {
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [
                imageView,
                areaView,
                nameLabel,
                priceLabel,
            ]
        )
        stackView.spacing = 4.0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubviewAndLayout(stackView)
    }
    
    func createImageView() -> UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layout {
            $0.height(238.0)
        }
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createAreaView() -> UIView {
        let imageView: UIImageView = UIImageView(image: CocoIcon.icActivityAreaIcon.image)
        imageView.contentMode = .scaleAspectFill
        imageView.layout {
            $0.size(20)
        }
        let contentView: UIView = UIView()
        contentView.addSubviews([
            imageView,
            areaLabel
        ])
        
        imageView.layout {
            $0.leading(to: contentView.leadingAnchor)
                .top(to: contentView.topAnchor)
                .bottom(to: contentView.bottomAnchor)
        }
        
        areaLabel.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 4.0)
                .centerY(to: contentView.centerYAnchor)
                .trailing(to: contentView.trailingAnchor, relation: .lessThanOrEqual)
        }
        
        return contentView
    }
}
