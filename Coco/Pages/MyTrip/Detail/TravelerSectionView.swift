//
//  TravelerSectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 18/08/25.
//

import UIKit

final class TravelerSectionView: UIView {
    
    // Callbacks ke VC / ViewModel
    var onAddTapped: (() -> Void)?
    var onRemoveTapped: ((UUID) -> Void)?
    
    // MARK: UI
    
    private let titleLabel: UILabel = {
        let l = UILabel(
            font: .jakartaSans(forTextStyle: .headline, weight: .bold),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        l.text = "Travelers in this trip"
        return l
    }()
    
    // Penampung baris-baris chip
    private let rows: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        v.alignment = .leading
        return v
    }()
    
    // --- NEW: cache + width tracking
    private var cachedTravelers: [Traveler] = []
    private var lastLaidOutWidth: CGFloat = 0
    // ---
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews([titleLabel, rows])
        titleLabel.layout {
            $0.leading(to: leadingAnchor).top(to: topAnchor).trailing(to: trailingAnchor)
        }
        rows.layout {
            $0.leading(to: leadingAnchor).top(to: titleLabel.bottomAnchor, constant: 12)
                .trailing(to: trailingAnchor).bottom(to: bottomAnchor)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // Public API
    func renderTravelers(_ travelers: [Traveler]) {
        cachedTravelers = travelers
        relayoutChips()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = rows.bounds.width
        if abs(width - lastLaidOutWidth) > 0.5 {
            lastLaidOutWidth = width
            relayoutChips()
        }
    }
    
    private func relayoutChips() {
        let availableWidth = max(rows.bounds.width, 0)
        guard availableWidth > 0 else { return }
        
        rows.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var currentRow = makeHStack()
        var currentWidth: CGFloat = 0
        rows.addArrangedSubview(currentRow)
        
        let chips: [UIView] = cachedTravelers.map { travelerChip($0) }
        
        for chip in chips {
            chip.setNeedsLayout(); chip.layoutIfNeeded()
            let size = chip.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let gap: CGFloat = currentWidth == 0 ? 0 : 12
            if currentWidth + gap + size.width > availableWidth {
                currentRow = makeHStack()
                rows.addArrangedSubview(currentRow)
                currentWidth = 0
            }
            if currentWidth > 0 { currentWidth += 12 }
            currentWidth += size.width
            currentRow.addArrangedSubview(chip)
        }
    }
    
    private func makeHStack() -> UIStackView {
        let h = UIStackView()
        h.axis = .horizontal
        h.spacing = 12
        h.alignment = .center
        return h
    }
    
    // smaller chip so 2/row fit comfortably
    private func travelerChip(_ t: Traveler) -> UIView {
        let container = UIView()
        container.backgroundColor = Token.additionalColorsWhite
        container.layer.borderWidth = 1
        container.layer.borderColor = Token.additionalColorsLine.cgColor
        container.layer.cornerRadius = 18
        
        container.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        
        let name = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .regular),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 1
        )
        name.text = t.name
        
        //        let close = UIButton(type: .system)
        //        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        //        close.tintColor = Token.grayscale60
        //        close.contentEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        //        close.addAction(UIAction { [weak self] _ in self?.onRemoveTapped?(t.id) }, for: .touchUpInside)
        
        container.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            name.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            name.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor), // ← important
            name.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor)
        ])
        //        name.layout {
        //            $0.leading(to: container.leadingAnchor, constant: 12)
        //                .top(to: container.topAnchor, constant: 6)
        //                .bottom(to: container.bottomAnchor, constant: -6)
        //        }
        //        close.layout {
        //            $0.leading(to: name.trailingAnchor, constant: 8)
        //                .trailing(to: container.trailingAnchor, constant: -12)
        //                .centerY(to: name.centerYAnchor)
        //        }
        container.heightAnchor.constraint(greaterThanOrEqualToConstant: 36).isActive = true
        return container
    }
    
    private func addChip() -> UIView {
        let b = UIButton(type: .system)
        b.setTitle("+", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        b.setTitleColor(Token.additionalColorsBlack, for: .normal)
        b.layer.cornerRadius = 18
        b.contentEdgeInsets = .zero
        b.heightAnchor.constraint(greaterThanOrEqualToConstant: 36).isActive = true
        b.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return b
    }
    
    @objc private func addTapped() { onAddTapped?() }
}

