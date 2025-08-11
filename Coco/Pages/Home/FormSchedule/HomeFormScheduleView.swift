//
//  HomeFormScheduleView.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation
import UIKit

struct HomeFormScheduleViewData {
    let imageString: String
    let activityName: String
    let packageName: String
    let location: String
}

final class HomeFormScheduleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(data: HomeFormScheduleViewData) {
        activityImage.loadImage(from: URL(string: data.imageString))
        activityTitle.text = data.activityName
        activityLocationTitle.text = data.location
        activityDescription.text = data.packageName
    }
    
    func addInputView(from view: UIView) {
        inputContainerView.subviews.forEach { $0.removeFromSuperview() }
        inputContainerView.addSubviewAndLayout(view)
    }
    
    private lazy var activityDetailView: UIView = createActivityDetailView()
    private lazy var activityImage: UIImageView = createImageView()
    private lazy var activityTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .title2, weight: .semibold),
        textColor: Token.grayscale90,
        numberOfLines: 0
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
    
    private lazy var inputContainerView: UIView = UIView()
}

private extension HomeFormScheduleView {
    func setupView() {
        backgroundColor = Token.additionalColorsWhite
        
        let sectionTitleLabel = UILabel(
            font: .jakartaSans(forTextStyle: .title3, weight: .bold),
            textColor: Token.grayscale90,
            numberOfLines: 0
        )
        sectionTitleLabel.text = "Schedule"
        
        let sectionStackView: UIStackView = UIStackView(arrangedSubviews: [
            activityDetailView,
            sectionTitleLabel
        ])
        sectionStackView.axis = .vertical
        sectionStackView.spacing = 16.0
        sectionStackView.distribution = .fillProportionally
        
        addSubview(sectionStackView)
        addSubview(inputContainerView)
        sectionStackView.layout {
            $0.top(to: self.safeAreaLayoutGuide.topAnchor, constant: 8.0)
                .leading(to: self.leadingAnchor, constant: 27.0)
                .trailing(to: self.trailingAnchor, constant: -27.0)
        }
        
        inputContainerView.layout {
            $0.top(to: sectionStackView.bottomAnchor, constant: 16.0)
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
}
