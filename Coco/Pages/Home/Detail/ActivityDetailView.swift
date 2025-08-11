//
//  ActivityDetailView.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import UIKit

protocol ActivityDetailViewDelegate: AnyObject {
    func notifyPackagesButtonDidTap(shouldShowAll: Bool)
    func notifyPackagesDetailDidTap(with packageId: Int)
}

final class ActivityDetailView: UIView {
    weak var delegate: ActivityDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ data: ActivityDetailDataModel) {
        titleLabel.text = data.title
        locationLabel.text = data.location
        
        // Detail section
        let detailDescription: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .headline, weight: .regular),
            textColor: Token.grayscale70,
            numberOfLines: 0
        )
        detailDescription.text = data.detailInfomation.content
        contentStackView.addArrangedSubview(
            createSectionView(
                title: data.detailInfomation.title,
                view: detailDescription
            )
        )
        
        // Trip Provider
        contentStackView.addArrangedSubview(
            createSectionView(
                title: data.providerDetail.title,
                view: createProviderDetail(
                    imageUrl: data.providerDetail.content.imageUrlString,
                    name: data.providerDetail.content.name,
                    description: data.providerDetail.content.description
                )
            )
        )
        
        // Facilities
        if !data.tripFacilities.content.isEmpty {
            contentStackView.addArrangedSubview(
                createSectionView(
                    title: data.tripFacilities.title,
                    view: createBenefitListView(titles: data.tripFacilities.content)
                )
            )
        }
        
        // TnC
        if !data.tnc.isEmpty {
            let tncLabel: UILabel = UILabel(
                font: .jakartaSans(forTextStyle: .footnote, weight: .regular),
                textColor: Token.additionalColorsBlack,
                numberOfLines: 0
            )
            tncLabel.text = data.tnc
            contentStackView.addArrangedSubview(createSectionView(
                title: "Terms and Conditon",
                view: tncLabel
            ))
        }
        
        if !data.availablePackages.content.isEmpty {
            contentStackView.addArrangedSubview(packageSection)
            
            if data.availablePackages.content.count == data.hiddenPackages.count {
                packageButton.isHidden = true
                data.availablePackages.content.forEach { data in
                    packageContainer.addArrangedSubview(createPackageView(data: data))
                }
            }
            else {
                data.hiddenPackages.forEach { data in
                    packageContainer.addArrangedSubview(createPackageView(data: data))
                }
            }
            
            packageLabel.text = data.availablePackages.title
        }
        
        packageLabel.isHidden = data.availablePackages.content.isEmpty
    }
    
    func addImageSliderView(with view: UIView) {
        imageSliderView.subviews.forEach { $0.removeFromSuperview() }
        imageSliderView.addSubviewAndLayout(view)
    }
    
    func toggleImageSliderView(isShown: Bool) {
        imageSliderView.isHidden = !isShown
    }
    
    func updatePackageData(_ data: [ActivityDetailDataModel.Package]) {
        packageContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in data.enumerated() {
            let view: UIView = createPackageView(data: item)
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: 0, y: 8)
            packageContainer.addArrangedSubview(view)

            UIView.animate(
                withDuration: 0.3,
                delay: 0.05 * Double(index),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut],
                animations: {
                    view.alpha = 1
                    view.transform = .identity
                }
            )
        }
    }
    
    private lazy var imageSliderView: UIView = UIView()
    private lazy var titleView: UIView = createTitleView()
    private lazy var titleLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .title2, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
    
    private lazy var locationLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 2
    )
    
    private lazy var packageSection: UIView = createPackageSection()
    private lazy var packageLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .subheadline, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
    private lazy var packageButton: UIButton = createPackageTextButton()
    
    private lazy var packageContainer: UIStackView = createStackView(spacing: 18.0)
    private lazy var contentStackView: UIStackView = createStackView(spacing: 29.0)
    private lazy var headerStackView: UIStackView = createStackView(spacing: 0)
    
    private lazy var isPackageButtonStateHidden: Bool = true
}

extension ActivityDetailView {
    func setupView() {
        let scrollView: UIScrollView = UIScrollView()
        let contentView: UIView = UIView()
        
        scrollView.addSubviewAndLayout(contentView)
        contentView.layout {
            $0.widthAnchor(to: scrollView.widthAnchor)
        }
        
        addSubviewAndLayout(scrollView)
        
        contentView.addSubviews([
            headerStackView,
            contentStackView
        ])
        
        headerStackView.backgroundColor = UIColor.from("#F5F5F5")
        headerStackView.addArrangedSubview(imageSliderView)
        headerStackView.addArrangedSubview(titleView)
        
        headerStackView.layout {
            $0.top(to: contentView.topAnchor)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        contentStackView.layout {
            $0.top(to: headerStackView.bottomAnchor, constant: -8.0)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
                .bottom(to: contentView.bottomAnchor)
        }
        
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = .init(vertical: 20.0, horizontal: 15.0)
        contentStackView.layer.cornerRadius = 24.0
        contentStackView.backgroundColor = Token.additionalColorsWhite
        
        scrollView.backgroundColor = UIColor.from("#F5F5F5")
        
        imageSliderView.isHidden = true
    }
}

private extension ActivityDetailView {
    func createStackView(
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis = .vertical
    ) -> UIStackView {
        let stackView: UIStackView = UIStackView()
        stackView.spacing = spacing
        stackView.axis = axis
        
        return stackView
    }
    
    func createSectionView(title: String, view: UIView) -> UIView {
        let contentView: UIView = UIView()
        let titleLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .bold),
            textColor: Token.additionalColorsBlack,
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
            $0.top(to: titleLabel.bottomAnchor, constant: 8.0)
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
            font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
            textColor: Token.grayscale90,
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
                .centerY(to: containerView.centerYAnchor)
        }
        
        label.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 4.0)
                .trailing(to: containerView.trailingAnchor)
                .centerY(to: containerView.centerYAnchor)
        }
        
        return containerView
    }
    
    func createTitleView() -> UIView {
        let pinPointImage: UIImageView = UIImageView(image: CocoIcon.icPinPointBlue.image)
        pinPointImage.layout {
            $0.size(20.0)
        }
        
        let locationView: UIView = UIView()
        locationView.addSubviews([
            pinPointImage,
            locationLabel
        ])
        
        pinPointImage.layout {
            $0.leading(to: locationView.leadingAnchor)
                .bottom(to: locationView.bottomAnchor)
                .top(to: locationView.topAnchor)
        }
        
        locationLabel.layout {
            $0.leading(to: pinPointImage.trailingAnchor, constant: 4.0)
                .trailing(to: locationView.trailingAnchor)
                .centerY(to: locationView.centerYAnchor)
        }
        
        let contentView: UIView = UIView()
        contentView.addSubviews([
            titleLabel,
            locationView
        ])
        
        titleLabel.layout {
            $0.leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
                .top(to: contentView.topAnchor)
        }
        
        locationView.layout {
            $0.top(to: titleLabel.bottomAnchor, constant: 8.0)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
                .bottom(to: contentView.bottomAnchor)
        }
        
        let contentWrapperView: UIView = UIView()
        contentWrapperView.addSubviewAndLayout(
            contentView,
            insets: .init(
                top: 16.0,
                left: 24.0,
                bottom: 16.0 + 8.0,
                right: 16.0
            )
        )
        
        return contentWrapperView
    }
    
    func createBenefitView(title: String) -> UIView {
        let contentView: UIView = UIView()
        let benefitImageView: UIImageView = UIImageView(image: CocoIcon.icCheckMarkFill.image)
        benefitImageView.layout {
            $0.size(24.0)
        }
        let benefitLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .footnote, weight: .regular),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 0
        )
        benefitLabel.text = title
        
        contentView.addSubviews([
            benefitImageView,
            benefitLabel
        ])
        
        benefitImageView.layout {
            $0.top(to: contentView.topAnchor)
                .leading(to: contentView.leadingAnchor)
                .bottom(to: contentView.bottomAnchor, relation: .lessThanOrEqual)
        }
        
        benefitLabel.layout {
            $0.leading(to: benefitImageView.trailingAnchor, constant: 4.0)
                .top(to: contentView.topAnchor)
                .bottom(to: contentView.bottomAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        return contentView
    }
    
    func createBenefitListView(titles: [String]) -> UIView {
        let stackView: UIStackView = createStackView(spacing: 12.0)
        
        titles.forEach { title in
            stackView.addArrangedSubview(createBenefitView(title: title))
        }
        
        return stackView
    }
    
    func createProviderDetail(imageUrl: String, name: String, description: String) -> UIView {
        let contentView: UIView = UIView()
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layout {
            $0.size(92.0)
        }
        imageView.layer.cornerRadius = 14.0
        imageView.loadImage(from: URL(string: imageUrl))
        imageView.clipsToBounds = true
        
        let nameLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        nameLabel.text = name
        
        let descriptionLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
            textColor: Token.grayscale90,
            numberOfLines: 0
        )
        descriptionLabel.text = description
        
        contentView.addSubviews([
            imageView,
            nameLabel,
            descriptionLabel,
        ])
        
        imageView.layout {
            $0.leading(to: contentView.leadingAnchor)
                .top(to: contentView.topAnchor)
                .bottom(to: contentView.bottomAnchor, relation: .lessThanOrEqual)
        }
        
        nameLabel.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 10.0)
                .top(to: contentView.topAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        descriptionLabel.layout {
            $0.leading(to: nameLabel.leadingAnchor)
                .top(to: nameLabel.bottomAnchor, constant: 8.0)
                .trailing(to: contentView.trailingAnchor)
                .bottom(to: contentView.bottomAnchor, relation: .lessThanOrEqual)
        }
        
        return contentView
    }
    
    func createPackageView(data: ActivityDetailDataModel.Package) -> UIView {
        let containerStackView: UIStackView = createStackView(spacing: 12.0, axis: .horizontal)
        let contentStackView: UIStackView = createStackView(spacing: 10.0)
        
        let headerStackView: UIStackView = createStackView(spacing: 12.0)
        headerStackView.alignment = .leading
        
        let footerContentView: UIView = UIView()
        
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layout {
            $0.size(92.0)
        }
        imageView.layer.cornerRadius = 14.0
        imageView.loadImage(from: URL(string: data.imageUrlString))
        imageView.clipsToBounds = true
        
        let nameLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        nameLabel.text = data.name
        
        let ratingAreaStackView: UIStackView = createStackView(spacing: 4.0, axis: .horizontal)
        ratingAreaStackView.alignment = .leading
        
        ratingAreaStackView.addArrangedSubview(
            createIconTextView(
                image: CocoIcon.icActivityAreaIcon.getImageWithTintColor(Token.grayscale70),
                text: data.description
            )
        )
        
        let priceLabel: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 2
        )
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(
            string: data.price,
            attributes: [
                .font : UIFont.jakartaSans(forTextStyle: .subheadline, weight: .bold),
                .foregroundColor : Token.additionalColorsBlack
            ]
        )
        
        attributedString.append(
            NSAttributedString(
                string: "/Person",
                attributes: [
                    .font : UIFont.jakartaSans(forTextStyle: .subheadline, weight: .medium),
                    .foregroundColor : Token.grayscale60
                ]
            )
        )
        
        priceLabel.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        priceLabel.attributedText = attributedString
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(contentStackView)
        
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(footerContentView)
        
        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(ratingAreaStackView)
        
        let action: UIAction = UIAction { [weak self] _ in
            self?.delegate?.notifyPackagesDetailDidTap(with: data.id)
        }
         
        var config = UIButton.Configuration.filled()
        config.image = CocoIcon.icArrowTopRight.image
        config.baseBackgroundColor = Token.mainColorPrimary
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule

        let button: UIButton = UIButton(configuration: config, primaryAction: action)
        button.layout {
            $0.size(40.0)
        }
        
        button.setContentHuggingPriority(.required + 1, for: .horizontal)
        button.setContentHuggingPriority(.required + 1, for: .vertical)

        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        
        footerContentView.addSubviews([
            priceLabel,
            button
        ])
        
        priceLabel.layout {
            $0.leading(to: footerContentView.leadingAnchor)
                .top(to: footerContentView.topAnchor)
                .bottom(to: footerContentView.bottomAnchor)
        }
        
        button.layout {
            $0.leading(to: priceLabel.trailingAnchor, relation: .lessThanOrEqual)
                .centerY(to: footerContentView.centerYAnchor)
                .trailing(to: footerContentView.trailingAnchor)
        }
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(edges: 12.0)
        containerStackView.layer.cornerRadius = 16.0
        containerStackView.backgroundColor = Token.mainColorForth
        
        return containerStackView
    }
    
    func createPackageSection() -> UIView {
        let containerView: UIView = UIView()
        containerView.addSubviews([
            packageLabel,
            packageButton
        ])
        
        packageButton.setContentHuggingPriority(.required, for: .horizontal)
        packageButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        packageLabel.layout {
            $0.leading(to: containerView.leadingAnchor)
                .top(to: containerView.topAnchor)
                .bottom(to: containerView.bottomAnchor)
        }
        
        packageButton.layout {
            $0.leading(to: packageLabel.trailingAnchor, constant: 4.0)
                .trailing(to: containerView.trailingAnchor)
                .centerY(to: containerView.centerYAnchor)
        }
        
        let contentView: UIView = UIView()
        contentView.addSubviews([
            containerView,
            packageContainer
        ])
        
        containerView.layout {
            $0.top(to: contentView.topAnchor)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        packageContainer.layout {
            $0.top(to: containerView.bottomAnchor, constant: 16.0)
                .bottom(to: contentView.bottomAnchor)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        return contentView
    }
    
    func createPackageTextButton() -> UIButton {
        let textButton: UIButton = UIButton.textButton(title: "Show All")
        textButton.addTarget(self, action: #selector(didTapTextButton), for: .touchUpInside)
        
        return textButton
    }
    
    @objc func didTapTextButton() {
        isPackageButtonStateHidden.toggle()
        packageButton.setTitle(isPackageButtonStateHidden ? "Show All" : "Show Less", for: .normal)
        delegate?.notifyPackagesButtonDidTap(shouldShowAll: !isPackageButtonStateHidden)
    }
}
