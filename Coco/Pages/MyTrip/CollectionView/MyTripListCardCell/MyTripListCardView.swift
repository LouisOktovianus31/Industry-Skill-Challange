//
//  MyTripListCardView.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Label Style Factory

enum MyTripLabelStyle {
    case date
    case trip
    case location
    case bookedBy
}

struct MyTripLabelFactory {
    static func make(_ style: MyTripLabelStyle) -> UILabel {
        switch style {
        case .date:
            return UILabel(
                font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
                textColor: Token.additionalColorsBlack,
                numberOfLines: 2
            )
        case .trip:
            return UILabel(
                font: .jakartaSans(forTextStyle: .headline, weight: .semibold),
                textColor: Token.additionalColorsBlack,
                numberOfLines: 2
            )
        case .location:
            return UILabel(
                font: .jakartaSans(forTextStyle: .footnote, weight: .regular),
                textColor: Token.grayscale90,
                numberOfLines: 2
            )
        case .bookedBy:
            return UILabel(
                font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
                textColor: Token.additionalColorsBlack,
                numberOfLines: 1
            )
        }
    }
}

protocol MyTripListCardViewDelegate: AnyObject {
    func notifyTripListCardDidTap(at id: Int)
    func notifyRebookDidTap(at id: Int)
}

final class MyTripListCardView: UICollectionViewCell {
    weak var delegate: MyTripListCardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(dataModel: MyTripListCardDataModel, index: Int) {
        self.bookingId = dataModel.id
        dateLabel.text = dataModel.dateText
        tripLabel.text = dataModel.title
        locationLabel.text = dataModel.location
        bookedByLabel.text = dataModel.bookedBy
        imageView.loadImage(from: URL(string: dataModel.imageUrl))
        
        createButtonView(dataModel: dataModel, index: index)
    }
    
    func createButtonView(dataModel: MyTripListCardDataModel, index: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        
        footerView.arrangedSubviews.forEach {
            footerView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        footerView.addArrangedSubview(detailButtonContainer.view)
        
        if dataModel.date < today {
            footerView.addArrangedSubview(rebookButtonContainer.view)
        }
    }
    
    private lazy var imageView: UIImageView = createImageView()
    private lazy var dateView: UIView = createDateView()
    private lazy var locationView: UIStackView = createLocationView()
    private lazy var leftSideView: UIStackView = createLeftSideView()
    private lazy var headerView: UIView = createHeaderView()
    private lazy var footerView: UIStackView = createFooterView()
    
    private lazy var dateLabel: UILabel = MyTripLabelFactory.make(.date)
    private lazy var tripLabel: UILabel = MyTripLabelFactory.make(.trip)
    private lazy var locationLabel: UILabel = MyTripLabelFactory.make(.location)
    private lazy var bookedByLabel: UILabel = MyTripLabelFactory.make(.bookedBy)
    private lazy var detailButtonContainer: CocoButtonHostingController = CocoButtonHostingController(
        action: { [weak self] in
            guard let self else { return }
            delegate?.notifyTripListCardDidTap(at: bookingId)
        },
        text: "Detail",
        style: .normal,
        type: .primary,
        isStretch: true
    )
    private lazy var rebookButtonContainer: CocoButtonHostingController = CocoButtonHostingController(
        action: { [weak self] in
            guard let self else { return }
            delegate?.notifyRebookDidTap(at: bookingId)
        },
        text: "Re - book",
        style: .normal,
        type: .secondary,
        isStretch: true
    )
    private var bookingId: Int = 0
}

private extension MyTripListCardView {
    func setupView() {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            headerView,
            footerView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.distribution = .fill
        
        addSubviewAndLayout(stackView, insets: UIEdgeInsets(edges: 12.0))
        
        backgroundColor = Token.additionalColorsWhite
        layer.cornerRadius = 16.0
        layer.borderWidth = 1.0
        layer.borderColor = Token.additionalColorsLine.cgColor
    }
    
    func createImageView() -> UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14.0
        imageView.layout {
            $0.width(89)
                .height(106)
        }
        
        return imageView
    }
    
    func createDateView() -> UIView {
        let dateView: UIView = UIView()
        dateView.addSubviews([
            dateLabel
        ])
        dateLabel.layout {
            $0.leading(to: dateView.leadingAnchor)
                .top(to: dateView.topAnchor)
                .bottom(to: dateView.bottomAnchor)
        }
        
        return dateView
    }
    
    func createLocationView() -> UIStackView {
        let locationIconImageView: UIImageView = UIImageView(image: CocoIcon.icPinPointBlue.getImageWithTintColor(Token.additionalColorsBlack))
        locationIconImageView.contentMode = .scaleAspectFill
        locationIconImageView.layout {
            $0.size(16)
        }
        let locationView: UIStackView = UIStackView(arrangedSubviews: [
            locationIconImageView,
            locationLabel
        ])
        locationView.axis = .horizontal
        locationView.spacing = 4.0
        locationView.distribution = .fillProportionally
        
        return locationView
    }
    
    func createLeftSideView() -> UIStackView {
        let leftSideView: UIStackView = UIStackView(arrangedSubviews: [
            dateView,
            tripLabel,
            locationView,
            bookedByLabel
        ])
        leftSideView.axis = .vertical
        leftSideView.spacing = 8.0
        leftSideView.distribution = .fillProportionally
        
        return leftSideView
    }
    
    func createHeaderView() -> UIView {
        let headerView: UIView = UIView()
        headerView.addSubviews([
            imageView,
            leftSideView
        ])
        imageView.layout {
            $0.leading(to: headerView.leadingAnchor)
                .top(to: headerView.topAnchor)
                .bottom(to: headerView.bottomAnchor, relation: .lessThanOrEqual)
        }
        leftSideView.layout {
            $0.leading(to: imageView.trailingAnchor, constant: 12.0)
                .top(to: headerView.topAnchor)
                .trailing(to: headerView.trailingAnchor)
                .bottom(to: headerView.bottomAnchor)
        }
        
        return headerView
    }
    
    func createFooterView() -> UIStackView {
        let footerView = UIStackView()
        footerView.axis = .horizontal
        footerView.spacing = 12.0
        footerView.distribution = .fill
        return footerView
    }
}
