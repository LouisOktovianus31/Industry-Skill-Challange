//
//  QRCodeSection.swift
//  Coco
//
//  Created by Grachia Uliari on 20/08/25.
//

import UIKit
import CoreImage

final class QRCodeSection: UIView {
    func configure(title: String = "View QR Code", payload: String){
        titleLabel.text = title
        qrImageView.image = makeQR(from: payload)
        qrWrapper.isHidden = !isExpanded
    }
    
    // UI
    private let card: UIView = {
        let qrCard = UIView()
        qrCard.backgroundColor = Token.additionalColorsWhite
        qrCard.layer.cornerRadius = 10
        qrCard.layer.borderColor = Token.additionalColorsLine.cgColor
        qrCard.layer.borderWidth = 1
        return qrCard
    }()
    
    private let titleLabel = UILabel(
        font: .jakartaSans(forTextStyle: .body, weight: .regular),
        textColor: Token.grayscale90,
        numberOfLines: 1
    )
    
    private let chevron: UIImageView = {
        let iv = UIImageView(image: CocoIcon.isChevronDown.image)
        iv.tintColor = Token.grayscale90
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iv
    }()
    
    private let header = UIView()
    
    // wrapper konten yang di-expand
    private let qrWrapper = UIView()
    
    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    // State
    private var isExpanded = false
    private var expandedBottom: NSLayoutConstraint!
    private var collapsedBottom: NSLayoutConstraint!
    
    // Init
    override init(frame: CGRect){
        super.init(frame: frame)
        build()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func build() {
        // Card
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: leadingAnchor),
            card.topAnchor.constraint(equalTo: topAnchor),
            card.trailingAnchor.constraint(equalTo: trailingAnchor),
            card.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Header (dalam card)
        card.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            header.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            header.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            header.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        header.addSubviews([titleLabel, chevron])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevron.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            chevron.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 20),
            chevron.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // QR wrapper
        card.addSubview(qrWrapper)
        qrWrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrWrapper.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            qrWrapper.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            qrWrapper.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            qrWrapper.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        qrWrapper.addSubview(qrImageView)
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrImageView.leadingAnchor.constraint(equalTo: qrWrapper.leadingAnchor),
            qrImageView.topAnchor.constraint(equalTo: qrWrapper.topAnchor),
            qrImageView.trailingAnchor.constraint(equalTo: qrWrapper.trailingAnchor),
            qrImageView.bottomAnchor.constraint(equalTo: qrWrapper.bottomAnchor),
            qrImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        // >>> Bottom constraints
        expandedBottom = qrWrapper.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        collapsedBottom = header.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        
        qrWrapper.isHidden = true
        expandedBottom.isActive = false
        collapsedBottom.isActive = true
        
        // Toggle expand
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleExpand))
        header.addGestureRecognizer(tap)
        header.isUserInteractionEnabled = true
    }
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        applyExpandedState(animated: true)
    }

    private func applyExpandedState(animated: Bool) {
        superview?.layoutIfNeeded()

        let animateToExpanded = {
            self.qrWrapper.alpha = 1
            self.qrWrapper.transform = .identity
            self.chevron.transform = CGAffineTransform(rotationAngle: .pi)
            self.superview?.layoutIfNeeded()
        }

        let animateToCollapsed = {
            self.qrWrapper.alpha = 0
            self.qrWrapper.transform = CGAffineTransform(translationX: 0, y: -8)
            self.chevron.transform = .identity
            self.superview?.layoutIfNeeded()
        }

        if animated {
            if isExpanded {
                // state awal sebelum animasi expand
                qrWrapper.isHidden = false
                qrWrapper.alpha = 0
                qrWrapper.transform = CGAffineTransform(translationX: 0, y: -8)

                // aktifkan constraint expanded, nonaktifkan collapsed
                expandedBottom.isActive = true
                collapsedBottom.isActive = false

                UIView.animate(
                    withDuration: 0.35,
                    delay: 0,
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 0.6,
                    options: [.curveEaseInOut],
                    animations: animateToExpanded,
                    completion: nil
                )
            } else {

                expandedBottom.isActive = false
                collapsedBottom.isActive = true

                UIView.animate(
                    withDuration: 0.28,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: animateToCollapsed,
                    completion: { _ in
                        self.qrWrapper.isHidden = true
                        self.qrWrapper.transform = .identity // reset
                    }
                )
            }
        } else {
            // tanpa animasi (saat pertama configure)
            if isExpanded {
                qrWrapper.isHidden = false
                expandedBottom.isActive = true
                collapsedBottom.isActive = false
                qrWrapper.alpha = 1
                qrWrapper.transform = .identity
                chevron.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                expandedBottom.isActive = false
                collapsedBottom.isActive = true
                qrWrapper.isHidden = true
                qrWrapper.alpha = 0
                qrWrapper.transform = .identity
                chevron.transform = .identity
            }
            superview?.layoutIfNeeded()
        }
    }

    private func makeQR(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel") // L/M/Q/H -> Medium
        
        guard let ciImage = filter.outputImage else { return nil } // menghasilkan CIImage QR Code yg ukurannya sangat kecil
        
        // Scale supaya tajam
        let scale: CGFloat = 8.0
        let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let context = CIContext()
        guard let cg = context.createCGImage(transformed, from: transformed.extent) else { return nil }
        return UIImage(cgImage: cg) // dibungkus jadi UIImage
    }
    
}
