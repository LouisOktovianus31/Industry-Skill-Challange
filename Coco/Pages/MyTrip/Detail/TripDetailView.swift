//
//  TripDetailView.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation
import UIKit

struct BookingDetailDataModel {
    let imageString: String
    let activityName: String
    let packageName: String
    let location: String
    
    let bookingDateText: String
    let status: StatusLabel
    let paxNumber: Int
    
    let price: Double
    
    let address: String
    
    struct StatusLabel {
        let text: String
        let style: CocoStatusLabelStyle
    }
    
    
    init(bookingDetail: BookingDetails) {
        var bookingStatus: String = bookingDetail.status
        var statusStyle: CocoStatusLabelStyle = .pending
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        if let targetDate: Date = formatter.date(from: bookingDetail.activityDate) {
            let today: Date = Date()
            
            if targetDate < today {
                bookingStatus = "Completed"
                statusStyle = .success
            }
            else if targetDate > today {
                bookingStatus = "Upcoming"
                statusStyle = .refund
            }
        }
        
        status = StatusLabel(text: bookingStatus, style: statusStyle)
        imageString = bookingDetail.destination.imageUrl ?? ""
        activityName = bookingDetail.activityTitle
        packageName = bookingDetail.packageName
        location = bookingDetail.destination.name
        paxNumber = bookingDetail.participants
        price = bookingDetail.totalPrice
        address = bookingDetail.address
        bookingDateText = bookingDetail.activityDate
    }
}

final class TripDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ data: BookingDetailDataModel) {
        activityImage.loadImage(from: URL(string: data.imageString))
        activityTitle.text = data.activityName
        activityLocationTitle.text = data.location
        activityDescription.text = data.packageName
        
        bookingDateLabel.text = data.bookingDateText
        paxNumberLabel.text = "\(data.paxNumber)"
        
        priceDetailTitle.text = "Pay During Trip"
        priceDetailPrice.text = "Rp\(data.price)"
        
        addressLabel.text = data.address
    }
    
    func configureStatusLabelView(with view: UIView) {
        statusLabel.addSubview(view)
        view.layout {
            $0.leading(to: statusLabel.leadingAnchor)
                .top(to: statusLabel.topAnchor)
                .trailing(to: statusLabel.trailingAnchor, relation: .lessThanOrEqual)
                .bottom(to: statusLabel.bottomAnchor)
        }
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
    
    private lazy var contentStackView: UIStackView = createStackView()
    
    private lazy var bookingDateSection: UIView = createSectionTitle(title: "Date Booking", view: bookingDateLabel)
    private lazy var bookingDateLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    
    private lazy var statusSection: UIView = createSectionTitle(title: "Status", view: statusLabel)
    private lazy var statusLabel: UIView = UIView()
    
    private lazy var paxNumberSection: UIView = createSectionTitle(title: "Person", view: paxNumberLabel)
    private lazy var paxNumberLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    
    private lazy var priceDetailTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .callout, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
    private lazy var priceDetailPrice: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .semibold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
    
    private lazy var addressSection: UIView = createSectionTitle(title: "Meeting Point", view: addressLabel)
    private lazy var addressLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    
    private lazy var priceDetailSection: UIView = createLeftRightAlignment(lhs: priceDetailTitle, rhs: priceDetailPrice)
}

private extension TripDetailView {
    func setupView() {
        addSubview(contentStackView)

        contentStackView.layout {
            $0.top(to: self.safeAreaLayoutGuide.topAnchor, constant: 24.0)
                .leading(to: self.leadingAnchor, constant: 24.0)
                .trailing(to: self.trailingAnchor, constant: -24.0)
                .bottom(to: self.bottomAnchor, relation: .lessThanOrEqual, constant: -24.0)
        }
        
        let dateStatusSection: UIView = UIView()
        dateStatusSection.addSubviews([
            bookingDateSection,
            statusSection
        ])
        
        bookingDateSection.layout {
            $0.leading(to: dateStatusSection.leadingAnchor)
                .centerY(to: dateStatusSection.centerYAnchor)
        }
        
        statusSection.layout {
            $0.leading(to: bookingDateSection.trailingAnchor)
                .leading(to: dateStatusSection.centerXAnchor)
                .trailing(to: dateStatusSection.trailingAnchor)
                .top(to: dateStatusSection.topAnchor)
                .bottom(to: dateStatusSection.bottomAnchor)
        }
        
        
        contentStackView.addArrangedSubview(activityDetailView)
        contentStackView.addArrangedSubview(dateStatusSection)
        contentStackView.addArrangedSubview(paxNumberSection)
        contentStackView.addArrangedSubview(createLineDivider())
        contentStackView.addArrangedSubview(priceDetailSection)
        contentStackView.addArrangedSubview(createLineDivider())
        contentStackView.addArrangedSubview(addressSection)
        
        backgroundColor = Token.additionalColorsWhite
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
    
    func createStackView() -> UIStackView {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24.0
          
        return stackView
    }
    
    func createSectionTitle(title: String, view: UIView) -> UIView {
        let titleView: UILabel = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .regular),
            textColor: Token.grayscale60,
            numberOfLines: 0
        )
        titleView.text = title
        
        let contentView: UIView = UIView()
        contentView.addSubviews(
            [
                titleView,
                view
            ]
        )
        
        titleView.layout {
            $0.leading(to: contentView.leadingAnchor)
                .top(to: contentView.topAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        view.layout {
            $0.leading(to: contentView.leadingAnchor)
                .top(to: titleView.bottomAnchor, constant: 4.0)
                .trailing(to: contentView.trailingAnchor)
                .bottom(to: contentView.bottomAnchor)
        }
        
        
        return contentView
    }
    
    func createLineDivider() -> UIView {
        let contentView: UIView = UIView()
        let divider: UIView = UIView()
        divider.backgroundColor = Token.additionalColorsLine
        divider.layout {
            $0.height(1.0)
        }
        
        contentView.addSubviewAndLayout(divider, insets: .init(vertical: 0, horizontal: 8.0))
        
        return contentView
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
