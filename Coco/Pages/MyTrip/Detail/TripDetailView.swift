import Foundation
import UIKit

struct HostDetail {
    let name: String
    let email: String
    let phone: String
}

struct BookingDetailDataModel {
    let imageString: String
    let activityName: String
    let packageName: String
    let location: String
    
    let bookingDateDisplay: String
    let status: StatusLabel
    let paxNumber: Int
    
    let priceText: String
    let address: String
    
    let host: HostDetail?
    
    let bookedByName: String
    
    let facilities: [String]
    
    struct StatusLabel {
        let text: String
        let style: CocoStatusLabelStyle
    }
    
    init(bookingDetail: BookingDetails) {
        var bookingStatus: String = bookingDetail.status
        var statusStyle: CocoStatusLabelStyle = .pending
        
        self.bookedByName = bookingDetail.user?.name ?? "Hany Wijaya"
        
        //        let formatter: DateFormatter = DateFormatter()
        //        formatter.dateFormat = "YYYY-MM-dd"
        
        if let targetDate = Formatters.apiDateParser.date(from: bookingDetail.activityDate) {
            let cal = Calendar(identifier: .gregorian)
            let today = cal.startOfDay(for: Date())
            let day = cal.startOfDay(for: targetDate)
            
            if day < today {
                bookingStatus = "Completed"
                statusStyle = .success
            }
            else if day > today {
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
        //        price = bookingDetail.totalPrice
        address = bookingDetail.address
        //        bookingDateText = bookingDetail.activityDate
        
        // display date
        if let d = Formatters.apiDateParser.date(from: bookingDetail.activityDate) {
            bookingDateDisplay = Formatters.tripDateDisplay.string(from: d)
        } else {
            bookingDateDisplay = bookingDetail.activityDate
        }
        
        // display price
        priceText = Formatters.idr(bookingDetail.totalPrice)
        
        if let vendor = bookingDetail.host {
            self.host = HostDetail(name: vendor.name, email: vendor.email ?? "host@gmail.com", phone: vendor.phone ?? "+62 812 3456 789")
        } else {
            self.host = nil
        }
        
        // facilities
        self.facilities = TripFacilitiesProvider.shared.facilities(for: bookingDetail)
    }
}

final class TripFacilitiesProvider {
    static let shared = TripFacilitiesProvider()
    private init() {}
    
    func facilities(for booking: BookingDetails) -> [String] {
        let name = booking.packageName.lowercased()
        let title = booking.activityTitle.lowercased()
        
        // Contoh aturan dummy
        if name.contains("snorkel") || title.contains("snorkel") {
            return ["Snorkeling Gear", "Life Jacket", "Bottled Water", "Certified Guide"]
        }
        if name.contains("liveaboard") {
            return ["Meals", "Cabin", "Dive Guide", "Towels"]
        }
        if booking.destination.name.lowercased().contains("bali") {
            return ["Certified Guide", "Free Meal", "Water Bottle"]
        }
        // default
        return ["Certified Guide", "Water Bottle"]
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
        //        activityDescriptionTitle.text = "Package"
        activityDescription.text = data.packageName
        
        activityDateLabel.text = data.bookingDateDisplay
        paxNumberLabel.text = "\(data.paxNumber) person"
        
        priceDetailTitle.text = "Pay on trip"
        priceDetailPrice.text = data.priceText
        
        addressLabel.text = data.address
        locationTextLabel.text = data.location
        
        bookedByNameValueLabel.text = data.bookedByName
        
        if let host = data.host {
            vendorNameValueLabel.text  = host.name
            vendorEmailValueLabel.text = host.email
            vendorPhoneValueLabel.text = host.phone
            vendorSectionView.isHidden = false
        } else {
            vendorNameValueLabel.text  = "Jeon Jungkook"
            vendorEmailValueLabel.text = "host@gmail.com"
            vendorPhoneValueLabel.text = "+62 8123456789"
            vendorSectionView.isHidden = false
        }
        
        if !data.facilities.isEmpty {
            let facilities = FacilitiesSectionView(title: "This Trip Includes", items: data.facilities)
            insertFacilitiesSection(facilities)
        }
        
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
    
    private let footer = StickyFooterView()
    
    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Invite traveler to space", for: .normal)
        button.setTitleColor(Token.additionalColorsWhite, for: .normal)
        button.backgroundColor = Token.mainColorPrimary
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .jakartaSans(forTextStyle: .body, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 14, right: 16)
        button.addTarget(self, action: #selector(addTripMemberTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityDetailView: UIView = createActivityDetailView()
    private lazy var activityImage: UIImageView = createImageView()
    private lazy var activityTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .title2, weight: .semibold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    
    private lazy var activityLocationTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 2
    )
    
    private lazy var activityDateLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .callout, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 0
    )
    
    private lazy var paxNumberLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 2
    )
    
    // Location (Maps)
    private lazy var locationIconView: UIImageView = {
        let iv = UIImageView(image: CocoIcon.icPinPointBlue.image)
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iv
    }()
    
    private lazy var locationTextLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .body, weight: .regular),
            textColor: Token.grayscale90,
            numberOfLines: 1
        )
        label.text = "Location…"
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var locationChevronView: UIImageView = {
        let iv = UIImageView(image: CocoIcon.icChevronRight.image)
        //        let img = CocoIcon.icChevronRight.image ?? UIImage(systemName: "chevronRight")
        //        let iv = UIImageView(image: img)
        iv.tintColor = Token.grayscale60
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iv
    }()
    
    private lazy var locationRow: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 6
        container.layer.borderWidth = 1
        container.layer.borderColor = Token.additionalColorsLine.cgColor
        container.backgroundColor = Token.additionalColorsWhite
        container.isUserInteractionEnabled = true
        
        container.layout { $0.height(52) }
        
        container.addSubviews([locationIconView, locationTextLabel, locationChevronView])
        
        locationIconView.layout {
            $0.leading(to: container.leadingAnchor, constant: 12)
                .centerY(to: container.centerYAnchor)
                .size(22)
        }
        
        locationTextLabel.layout {
            $0.leading(to: locationIconView.trailingAnchor, constant: 10)
                .trailing(to: locationChevronView.leadingAnchor, constant: -10)
                .centerY(to: container.centerYAnchor)
        }
        
        locationChevronView.layout {
            $0.trailing(to: container.trailingAnchor, constant: -12)
                .centerY(to: container.centerYAnchor)
                .size(22)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLocationRow))
        container.addGestureRecognizer(tap)
        
        return container
    }()
    
    private lazy var bookingDateSection: UIView = createSectionTitle(title: "Date Booking", view: bookingDateLabel)
    private lazy var bookingDateLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    
    // Booked By
    private lazy var bookedByName: UIView = UIView()
    
    private lazy var bookedByTitleLabel: UILabel = {
        let title = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        title.text = "Booked by"
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return title
    }()
    
    private lazy var bookedByNameRow: UIView = {
        bookedByName.setContentHuggingPriority(.required, for: .horizontal)
        bookedByName.setContentCompressionResistancePriority(.required, for: .horizontal)
        return createLeftRightAlignment(lhs: bookedByTitleLabel, rhs: bookedByNameValueLabel)
    }()
    
    private lazy var bookedByNameValueLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .medium),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    //    private lazy var statusSection: UIView = createSectionTitle(title: "Status", view: statusLabel)
    private lazy var statusLabel: UIView = UIView()
    
    private lazy var statusTitleLabel: UILabel = {
        let title = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        title.text = "Status"
        // supaya title nempel di kanan
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return title
    }()
    
    private lazy var statusRow: UIView = {
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        return createLeftRightAlignment(lhs: statusTitleLabel, rhs: statusLabel)
    }()
    
    private lazy var priceDetailSection: UIView = createLeftRightAlignment(lhs: priceDetailTitle, rhs: priceDetailPrice)
    
    private lazy var priceDetailPrice: UILabel = {
        let l = UILabel(
            font: .jakartaSans(forTextStyle: .headline, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        l.textAlignment = .right
        l.setContentCompressionResistancePriority(.required, for: .horizontal)
        l.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return l
    }()
    
    private lazy var priceDetailTitle: UILabel = {
        let l = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        l.setContentHuggingPriority(.required, for: .horizontal)
        return l
    }()
    
    
    //    private lazy var packageNameSection: UIView = createSectionTitle(title: "Package Name", view: activityDescriptionTitle)
    //
    
    private lazy var activityDescriptionTitle: UILabel = {
        let title = UILabel(
            font: .jakartaSans(forTextStyle: .headline, weight: .bold),
            //            font: .jakartaSans(forTextStyle: .title2, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        title.text = "Package"
        // supaya title nempel di kanan
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return title
    }()
    
    private lazy var activityDescription: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .callout, weight: .medium),
        textColor: Token.additionalColorsBlack
        //        numberOfLines: 2
    )
    
    private lazy var packageRow: UIView = {
        activityDescriptionTitle.setContentHuggingPriority(.required, for: .horizontal)
        activityDescription.setContentCompressionResistancePriority(.required, for: .horizontal)
        activityDescription.textAlignment = .right
        return createLeftRightAlignment(lhs: activityDescriptionTitle, rhs: activityDescription)
    }()
    
    
    private lazy var addressSection: UIView = createSectionTitle(title: "Meeting Point", view: addressLabel)
    private lazy var addressLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    
    // Vendor Section
    private lazy var vendorSectionView: UIView = createVendorSection()
    
    private lazy var vendorTitleLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        label.text = "Vendor Contact"
        return label
    }()
    
    private lazy var vendorNameKeyLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .regular),
            textColor: Token.grayscale90,
            numberOfLines: 1
        )
        label.text = "Name"
        return label
    }()
    
    private lazy var vendorEmailKeyLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .regular),
            textColor: Token.grayscale90,
            numberOfLines: 1
        )
        label.text = "Email"
        return label
    }()
    
    private lazy var vendorPhoneKeyLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .regular),
            textColor: Token.grayscale90,
            numberOfLines: 1
        )
        label.text = "Phone"
        return label
    }()
    
    private lazy var vendorNameValueLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var vendorEmailValueLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var vendorPhoneValueLabel: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .callout, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Travelers Section
    private let travelerSection = TravelerSectionView()
    
    var onInviteTapped: (() -> Void)? {
        get { travelerSection.onAddTapped }
        set { travelerSection.onAddTapped = newValue }
    }
    
    var onRemoveTraveler: ((UUID) -> Void)? {
        get { travelerSection.onRemoveTapped }
        set { travelerSection.onRemoveTapped = newValue }
    }
    
    func renderTravelers(_ travelers: [Traveler]) {
        travelerSection.renderTravelers(travelers)
    }
    
}

private extension TripDetailView {
    @objc func didTapLocationRow() {
        // utk lanjut ke gmaps
        print("Location row tapped")
    }
    
    private func insertFacilitiesSection(_ view: UIView) {
        // Contoh: taruh setelah locationRow (cari index-nya di stack)
        if let idx = contentStackView.arrangedSubviews.firstIndex(of: locationRow) {
            contentStackView.insertArrangedSubview(view, at: idx + 1)
        } else {
            contentStackView.addArrangedSubview(view)
        }
    }
    
    func setupView() {
        // 1) Tambah scrollView lalu isi dengan stack
        addSubview(scrollView)
        addSubview(footer)
        scrollView.addSubview(contentStackView)
        
        // 2) Pin scrollView ke tepi view
        //        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 3) Pin konten ke contentLayoutGuide (untuk ukuran content)
        //        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            
            // lebar konten mengikuti lebar viewport (tanpa scroll horizontal)
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48)
        ])
        
        // Footer (sticky)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.backgroundColor = Token.additionalColorsWhite
        NSLayoutConstraint.activate([
            footer.leadingAnchor.constraint(equalTo: leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        footer.button.addTarget(self, action: #selector(addTripMemberTapped), for: .touchUpInside)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let footerH = self.footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.scrollView.contentInset.bottom = footerH
            self.scrollView.verticalScrollIndicatorInsets.bottom = footerH
        }
        
        backgroundColor = Token.additionalColorsWhite
        
        let dateStatusSection: UIView = UIView()
        dateStatusSection.addSubviews([
            bookingDateSection
        ])
        
        bookingDateSection.layout {
            $0.leading(to: dateStatusSection.leadingAnchor)
                .centerY(to: dateStatusSection.centerYAnchor)
        }
        
        let actionSection = ActionSectionView()
        let importantNoticeSection = ImportantNoticeSectionView()
        
        // URUTAN VSTACK
        contentStackView.addArrangedSubview(activityDetailView)
        contentStackView.addArrangedSubview(createLineDivider())
        contentStackView.addArrangedSubview(bookedByNameRow)
        contentStackView.addArrangedSubview(statusRow)
        contentStackView.addArrangedSubview(createDashedDivider())
        contentStackView.addArrangedSubview(packageRow)
        contentStackView.addArrangedSubview(priceDetailSection)
        contentStackView.addArrangedSubview(locationRow)
        contentStackView.addArrangedSubview(createLineDivider())
        contentStackView.addArrangedSubview(travelerSection)
        contentStackView.addArrangedSubview(vendorSectionView)
        contentStackView.addArrangedSubview(actionSection)
        contentStackView.addArrangedSubview(importantNoticeSection)
//        contentStackView.addArrangedSubview(addressSection)
        
        backgroundColor = Token.additionalColorsWhite
    }
    
    func createActivityDetailView() -> UIView {
        let containerView: UIView = UIView()
        containerView.addSubviews([
            activityImage,
            activityTitle,
            activityDateLabel,
            paxNumberLabel
        ])
        
        activityImage.layout {
            $0.leading(to: containerView.leadingAnchor) // nempel di sisi kiri container
                .top(to: containerView.topAnchor) // nempel di atas container
                .bottom(to: containerView.bottomAnchor, relation: .lessThanOrEqual) // tinggi nya lebih kecil dari container
        }
        activityTitle.layout {
            $0.leading(to: activityImage.trailingAnchor, constant: 10.0)
                .top(to: containerView.topAnchor)
                .trailing(to: containerView.trailingAnchor)
        }
        activityDateLabel.layout {
            $0.leading(to: activityTitle.leadingAnchor)
                .top(to: activityTitle.bottomAnchor, constant: 4.0)
                .trailing(to: containerView.trailingAnchor)
        }
        paxNumberLabel.layout {
            $0.leading(to: activityDateLabel.leadingAnchor)
                .top(to: activityDateLabel.bottomAnchor, constant: 4.0)
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
    
    func createDashedDivider() -> UIView {
        let contentView = UIView()
        
        let dashedView = DashedLineView()
        dashedView.backgroundColor = .clear
        
        contentView.addSubviewAndLayout(dashedView, insets: .init(vertical: 0, horizontal: 0))
        dashedView.layout {
            $0.height(1.0)
        }
        
        return contentView
    }
    final class DashedLineView: UIView {
        private let shapeLayer = CAShapeLayer()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(shapeLayer)
            shapeLayer.strokeColor = Token.additionalColorsLine.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [4, 4] // 4px garis, 4px jarak
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let path = UIBezierPath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            shapeLayer.path = path.cgPath
        }
    }
    func createLeftRightAlignment(lhs: UIView, rhs: UIView) -> UIView {
        let container = UIView()
        container.addSubviews([lhs, rhs])
        
        // ← kunci: prioritas default (bisa ditimpa di instance masing-masing)
        lhs.setContentHuggingPriority(.required, for: .horizontal)
        lhs.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        rhs.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rhs.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        lhs.layout {
            $0.leading(to: container.leadingAnchor)
                .top(to: container.topAnchor)
        }
        rhs.layout {
            $0.leading(to: lhs.trailingAnchor, relation: .greaterThanOrEqual, constant: 12)
                .trailing(to: container.trailingAnchor)
                .top(to: container.topAnchor)
                .bottom(to: container.bottomAnchor)   // tinggi baris mengikuti konten tertinggi
        }
        return container
    }
    func createKeyValueRow(key: UILabel, value: UILabel) -> UIView {
        let row = UIView()
        row.addSubviews([key, value])
        
        key.setContentCompressionResistancePriority(.required, for: .horizontal)
        key.setContentHuggingPriority(.required, for: .horizontal)
        value.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        value.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        key.layout {
            $0.leading(to: row.leadingAnchor)
                .top(to: row.topAnchor)
                .bottom(to: row.bottomAnchor)
        }
        value.layout {
            $0.leading(to: key.trailingAnchor, constant: 16)
                .trailing(to: row.trailingAnchor)
                .centerY(to: row.centerYAnchor)
        }
        return row
    }
    func createVendorSection() -> UIView {
        let container = UIView()
        let rowName  = createKeyValueRow(key: vendorNameKeyLabel,  value: vendorNameValueLabel)
        let rowEmail = createKeyValueRow(key: vendorEmailKeyLabel, value: vendorEmailValueLabel)
        let rowPhone = createKeyValueRow(key: vendorPhoneKeyLabel, value: vendorPhoneValueLabel)
        let stack = UIStackView(arrangedSubviews: [vendorTitleLabel, rowName, rowEmail, rowPhone])
        stack.axis = .vertical
        stack.spacing = 8
        container.addSubview(stack)
        stack.layout {
            $0.leading(to: container.leadingAnchor)
                .top(to: container.topAnchor)
                .trailing(to: container.trailingAnchor)
                .bottom(to: container.bottomAnchor)
        }
        return container
    }
    @objc private func addTripMemberTapped() {
        print("Invite traveler to space")
    }
}
