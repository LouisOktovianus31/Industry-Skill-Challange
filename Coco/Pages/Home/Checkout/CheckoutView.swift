//
//  CheckoutView.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation
import UIKit

final class CheckoutView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ data: BookingDetails) {
        if let imageUrl: String = data.destination.imageUrl, imageUrl.count > 0{
            activityImage.loadImage(from: URL(string: imageUrl))
        }
        
        activityTitle.text = data.activityTitle
        activityDescription.text = data.packageName
        activityLocationTitle.text = data.destination.name
        
        let vacationStackView: UIStackView = UIStackView()
        vacationStackView.axis = .vertical
        vacationStackView.spacing = 12.0
        
        let participantTotalLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        participantTotalLabel.text = "\(data.participants)"
        vacationStackView.addArrangedSubview(
            createLeftRightAlignment(
                lhs: createIconTextView(
                    image: CocoIcon.icuserIcon.image,
                    text: "Person"
                ),
                rhs: participantTotalLabel
            )
        )
        
        let dateTotalLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        dateTotalLabel.text = data.activityDate
        vacationStackView.addArrangedSubview(
            createLeftRightAlignment(
                lhs: createIconTextView(
                    image: CocoIcon.icCalendarIcon.image,
                    text: "Dates"
                ),
                rhs: dateTotalLabel
            )
        )
        
        cardSectionStackView.addArrangedSubview(
            createSectionView(
                title: "Your Vacation",
                view: vacationStackView
            )
        )
        
        let priceDetailTitle: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        priceDetailTitle.text = "Pay During Trip"
        
        let priceDetailPrice: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .body, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        priceDetailPrice.text = "Rp\(data.totalPrice)"
        
        cardSectionStackView.addArrangedSubview(
            createSectionView(
                title: "Price Details",
                view: createLeftRightAlignment(lhs: priceDetailTitle, rhs: priceDetailPrice)
            )
        )
    }
    
    func addBooknowButton(from view: UIView) {
        bookNowButtonContainer.subviews.forEach { $0.removeFromSuperview() }
        bookNowButtonContainer.addSubviewAndLayout(view)
    }
    
    private lazy var cardSectionStackView: UIStackView = crateCardSectionStackView()
    
    private lazy var activityDetailView: UIView = createActivityDetailView()
    private lazy var activityImage: UIImageView = createImageView()
    private lazy var activityTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .title2, weight: .semibold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 1
    )
    private lazy var activityDescription: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .callout, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 0
    )
    private lazy var activityLocationTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 2
    )
    private lazy var bookNowButtonContainer: UIView = UIView()
}

private extension CheckoutView {
    func crateCardSectionStackView() -> UIStackView {
        let sectionStackView: UIStackView = UIStackView(arrangedSubviews: [
            activityDetailView,
            
        ])
        sectionStackView.axis = .vertical
        sectionStackView.spacing = 16.0
        
        return sectionStackView
    }
    
    func setupView() {
        backgroundColor = Token.additionalColorsWhite
        
        let containerCardView: UIView = UIView()
        containerCardView.addSubviewAndLayout(
            cardSectionStackView,
            insets: UIEdgeInsets(edges: 16.0)
        )
        containerCardView.layer.cornerRadius = 14.0
        containerCardView.layer.borderWidth = 1.0
        containerCardView.layer.borderColor = Token.additionalColorsLine.cgColor
        
        addSubview(containerCardView)
        addSubview(bookNowButtonContainer)
        containerCardView.layout {
            $0.top(to: self.safeAreaLayoutGuide.topAnchor, constant: 8.0)
                .leading(to: self.leadingAnchor, constant: 27.0)
                .trailing(to: self.trailingAnchor, constant: -27.0)
        }
        
        bookNowButtonContainer.layout {
            $0.top(to: containerCardView.bottomAnchor, relation: .greaterThanOrEqual, constant: 8.0)
                .leading(to: self.leadingAnchor, constant: 27.0)
                .trailing(to: self.trailingAnchor, constant: -27.0)
                .bottom(to: self.bottomAnchor, constant: -8.0)
        }
    }
    
    func createImageView() -> UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layout {
            $0.size(92.0)
        }
        imageView.layer.cornerRadius = 14.0
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createActivityDetailView() -> UIView {
        let imageView: UIImageView = UIImageView(image: CocoIcon.icPinPointBlue.image)
        imageView.layout {
            $0.size(20.0)
        }
        
        let imageTextContent: UIView = UIView()
        imageTextContent.addSubviews([
            imageView,
            activityLocationTitle
        ])
        
        imageView.layout {
            $0.leading(to: imageTextContent.leadingAnchor)
                .top(to: imageTextContent.topAnchor)
                .bottom(to: imageTextContent.bottomAnchor)
                .centerY(to: imageTextContent.centerYAnchor)
        }
        
        activityLocationTitle.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 4.0)
                .trailing(to: imageTextContent.trailingAnchor)
                .centerY(to: imageTextContent.centerYAnchor)
        }
        
        let containerView: UIView = UIView()
        containerView.addSubviews([
            activityImage,
            activityTitle,
            activityDescription,
            imageTextContent
        ])
        
        activityImage.layout {
            $0.leading(to: containerView.leadingAnchor)
                .top(to: containerView.topAnchor)
                .bottom(to: containerView.bottomAnchor, relation: .lessThanOrEqual)
        }
        
        activityTitle.layout {
            $0.leading(to: activityImage.trailingAnchor, constant: 10.0)
                .top(to: containerView.topAnchor)
                .trailing(to: containerView.trailingAnchor)
        }
        
        activityDescription.layout {
            $0.leading(to: activityTitle.leadingAnchor)
                .top(to: activityTitle.bottomAnchor, constant: 8.0)
                .trailing(to: containerView.trailingAnchor)
        }
        
        imageTextContent.layout {
            $0.leading(to: activityTitle.leadingAnchor)
                .top(to: activityDescription.bottomAnchor, constant: 8.0)
                .trailing(to: containerView.trailingAnchor)
                .bottom(to: containerView.bottomAnchor)
        }
        
        return containerView
    }
    
    func createSectionView(title: String, view: UIView) -> UIView {
        let contentView: UIView = UIView()
        let titleLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .body, weight: .bold),
            textColor: Token.grayscale60,
            numberOfLines: 2
        )
        titleLabel.text = title
        
        contentView.addSubviews([
            titleLabel,
            view
        ])
        
        titleLabel.layout {
            $0.top(to: contentView.topAnchor)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        view.layout {
            $0.top(to: titleLabel.bottomAnchor, constant: 16.0)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
                .bottom(to: contentView.bottomAnchor)
        }
        
        return contentView
    }
    
    func createIconTextView(image: UIImage, text: String) -> UIView {
        let imageView: UIImageView = UIImageView(image: image)
        imageView.layout {
            $0.size(20.0)
        }
        
        let label: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .medium),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        label.text = text
        
        let containerView: UIView = UIView()
        containerView.addSubviews([
            imageView,
            label
        ])
        
        imageView.layout {
            $0.leading(to: containerView.leadingAnchor)
                .top(to: containerView.topAnchor)
                .bottom(to: containerView.bottomAnchor)
        }
        
        label.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 4.0)
                .trailing(to: containerView.trailingAnchor)
                .centerY(to: containerView.centerYAnchor)
        }
        
        return containerView
    }
    
    func createLeftRightAlignment(
        lhs: UIView,
        rhs: UIView
    ) -> UIView {
        let containerView: UIView = UIView()
        containerView.addSubviews([
            lhs,
            rhs
        ])
        lhs.layout {
            $0.leading(to: containerView.leadingAnchor)
                .top(to: containerView.topAnchor)
                .bottom(to: containerView.bottomAnchor)
        }
        
        rhs.layout {
            $0.leading(to: lhs.trailingAnchor, relation: .greaterThanOrEqual,  constant: 4.0)
                .trailing(to: containerView.trailingAnchor)
                .centerY(to: containerView.centerYAnchor)
        }
        
        return containerView
    }
}
