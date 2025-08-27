import Foundation
import UIKit

final class TripDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        addCalendarSection.onTap = { [weak self] in
            self?.action?.onAddCalendarDidTap()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let facilitiesSectionView = FacilitiesSectionView(title: "This Trip Includes", items: [])
    
    private let qrSection = QRCodeSection()
    
    func configureStatusLabelView(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.addSubview(view)
        view.layout {
            $0.leading(to: statusLabel.leadingAnchor)
                .top(to: statusLabel.topAnchor)
                .trailing(to: statusLabel.trailingAnchor, relation: .lessThanOrEqual)
                .bottom(to: statusLabel.bottomAnchor)
        }
    }
    
    func configureFooterView(_ isShow: Bool) {
        footer.isHidden = !isShow
    }
    
    func configureFooterViewAction(action: @escaping () -> Void) {
        self.footerAction = action
        footer.button.addTarget(self, action: #selector(handleFooterTap), for: .touchUpInside)
    }
    
    @objc private func handleFooterTap() {
        footerAction?()
    }
    
    private var footerAction: (() -> Void)?
    private let footer = StickyFooterView()
    
    private lazy var activityDetailView: UIView = createActivityDetailView()
    private lazy var activityImage: UIImageView = createImageView()
    private lazy var activityTitle: UILabel = {
        let label = UILabel(
            font: .jakartaSans(forTextStyle: .title2, weight: .semibold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 0
        )
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var activityLocationTitle: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 2
    )
    
    private let iconCalendarView: UIImageView = {
        let iconview = UIImageView(image: CocoIcon.icCalendarIcon.image)
        iconview.contentMode = .scaleAspectFit
        iconview.setContentHuggingPriority(.required, for: .horizontal)
        iconview.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iconview
    }()
    
    private let iconUserView: UIImageView = {
        let iconview = UIImageView(image: CocoIcon.icuserIcon.image)
        iconview.contentMode = .scaleAspectFit
        iconview.setContentHuggingPriority(.required, for: .horizontal)
        iconview.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iconview
    }()
    
    private lazy var activityDateLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .callout, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 0
    )
    
    private lazy var paxNumberLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .footnote, weight: .medium),
        textColor: Token.grayscale90,
        numberOfLines: 1
    )
    
    
    // Location (Maps)
    private let locationSection = LocationSectionView()
    
    var onLocationTapped: (() -> Void)? {
        get { locationSection.onTap }
        set { locationSection.onTap = newValue }
    }
    
    // WhatsApp
    private let whatsAppSection = WhatsAppSectionView()
    
    var onWhatsAppTapped: (() -> Void)? {
        get { whatsAppSection.onTap }
        set { whatsAppSection.onTap = newValue }
    }
    
    // Calendar
    private let addCalendarSection = AddCalendarSectionView()
    weak var action: TripDetailViewModelAction?
    
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
    
//    var onInviteTapped: (() -> Void)? {
//        get { travelerSection.onAddTapped }
//        set { travelerSection.onAddTapped = newValue }
//    }
//    
//    var onRemoveTraveler: ((UUID) -> Void)? {
//        get { travelerSection.onRemoveTapped }
//        set { travelerSection.onRemoveTapped = newValue }
//    }
    
    func renderTravelers(_ travelers: [Traveler]) {
        travelerSection.renderTravelers(travelers)
    }
}

extension TripDetailView {
    @objc func didTapLocationRow() {
        // utk lanjut ke gmaps
        print("Location row tapped")
    }
    
    func render(_ state: TripDetailViewState) {
            // hero
            activityImage.loadImage(from: state.imageURL)
            activityTitle.text = state.title
            activityLocationTitle.text = state.locationText

            // info kecil
            activityDateLabel.text = state.dateText
            paxNumberLabel.text = state.paxText

            // package & price
            activityDescription.text = state.packageName
            priceDetailTitle.text = "Pay on trip"
            priceDetailPrice.text = state.priceText

            // meeting point
            addressLabel.text = state.addressText
            locationSection.configure(text: state.locationText)

            bookedByNameValueLabel.text = state.plannerName
        
            vendorNameValueLabel.text  = state.vendorName
            vendorPhoneValueLabel.text = state.vendorContact

            // facilities / accessories
            facilitiesSectionView.isHidden = !state.showFacilities
            facilitiesSectionView.update(items: state.includedAccessories)

            // WhatsApp & QR
            whatsAppSection.configure(title: state.waTitle)
            qrSection.configure(title: state.qrTitle, payload: state.qrPayload)

            // Vendor
//            if let v = state.vendor {
//                vendorNameValueLabel.text  = v.name
//                vendorEmailValueLabel.text = v.email
//                vendorPhoneValueLabel.text = v.phone
//                vendorSectionView.isHidden = false
//            } else {
//                vendorSectionView.isHidden = true
//            }
        }
    
    func clearStatusView() {
        statusLabel.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func setupView() {
        // 1) Tambah scrollView lalu isi dengan stack
        addSubview(scrollView)
        addSubview(footer)
        footer.isHidden = true
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
        
        let importantNoticeSection = ImportantNoticeSectionView()
        
        // URUTAN VSTACK
        contentStackView.addArrangedSubview(activityDetailView)
        contentStackView.addArrangedSubview(locationSection)
        contentStackView.addArrangedSubview(createLineDivider())
        contentStackView.addArrangedSubview(bookedByNameRow)
        contentStackView.addArrangedSubview(statusRow)
        contentStackView.addArrangedSubview(createDashedDivider())
        contentStackView.addArrangedSubview(packageRow)
        contentStackView.addArrangedSubview(priceDetailSection)
        contentStackView.addArrangedSubview(qrSection)
        contentStackView.addArrangedSubview(facilitiesSectionView)
        contentStackView.addArrangedSubview(createLineDivider())
        contentStackView.addArrangedSubview(travelerSection)
        contentStackView.addArrangedSubview(vendorSectionView)
        contentStackView.addArrangedSubview(whatsAppSection)
        contentStackView.addArrangedSubview(addCalendarSection)
        contentStackView.addArrangedSubview(importantNoticeSection)
        //        contentStackView.addArrangedSubview(addressSection)
        
        backgroundColor = Token.additionalColorsWhite
    }
    
    func createActivityDetailView() -> UIView {
        let container = UIView()

        // 1) Image & Title
        container.addSubviews([activityImage, activityTitle])

//        activityImage.layout {
//            $0.leading(to: container.leadingAnchor)
//                .top(to: container.topAnchor)
//                .size(105.0)
//        }

        activityTitle.layout {
            $0.leading(to: activityImage.trailingAnchor, constant: 12)
                .top(to: container.topAnchor)
                .trailing(to: container.trailingAnchor)
        }

        // 2) Baris "date" (ikon + text)
        let dateRow = UIView()
        dateRow.addSubviews([iconCalendarView, activityDateLabel])

        iconCalendarView.layout {
            $0.leading(to: dateRow.leadingAnchor)
                .centerY(to: dateRow.centerYAnchor)
                .size(20)
        }
        activityDateLabel.layout {
            $0.leading(to: iconCalendarView.trailingAnchor, constant: 8)
                .top(to: dateRow.topAnchor)
                .trailing(to: dateRow.trailingAnchor)
                .bottom(to: dateRow.bottomAnchor)
        }

        // 3) Baris "person" (icon + text)
        let personRow = UIView()
        personRow.addSubviews([iconUserView, paxNumberLabel])

        iconUserView.layout {
            $0.leading(to: personRow.leadingAnchor)
                .centerY(to: personRow.centerYAnchor)
                .size(20)
        }
        paxNumberLabel.layout {
            $0.leading(to: iconUserView.trailingAnchor, constant: 8)
                .top(to: personRow.topAnchor)
                .trailing(to: personRow.trailingAnchor)
                .bottom(to: personRow.bottomAnchor)
        }
        
        paxNumberLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        activityDateLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        // 4) Stack utk meta info: date + person (jarak konstan)
        let metaStack = UIStackView(arrangedSubviews: [dateRow, personRow])
        metaStack.axis = .vertical
        metaStack.spacing = 6
        metaStack.alignment = .fill
        metaStack.distribution = .fill

        container.addSubview(metaStack)
        metaStack.layout {
            $0.leading(to: activityTitle.leadingAnchor)
                .top(to: activityTitle.bottomAnchor, constant: 6)
                .trailing(to: container.trailingAnchor)
                .bottom(to: container.bottomAnchor)
        }

        activityImage.layout {
            $0.leading(to: container.leadingAnchor)
                .bottom(to: personRow.bottomAnchor, relation: .greaterThanOrEqual)
                .top(to: container.topAnchor, relation: .greaterThanOrEqual)
                
        }

        return container
    }

    func createImageView() -> UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layout {
            $0.size(102.0)
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
//        let rowEmail = createKeyValueRow(key: vendorEmailKeyLabel, value: vendorEmailValueLabel)
        let rowPhone = createKeyValueRow(key: vendorPhoneKeyLabel, value: vendorPhoneValueLabel)
        let stack = UIStackView(arrangedSubviews: [vendorTitleLabel, rowName, rowPhone])
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
}
