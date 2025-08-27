//
//  FacilitiesSectionView.swift
//  Coco
//
//  Created by Grachia Uliari on 18/08/25.
//

import UIKit

final class FacilitiesSectionView: UIView {

    // simpan referensi komponen agar bisa di-update
    private let titleLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .headline, weight: .bold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 1
    )

    private let vstack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 12
        return s
    }()

    init(title: String, items: [String]) {
        super.init(frame: .zero)
        setupLayout()
        update(title: title, items: items)
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        addSubviews([titleLabel, vstack])
        titleLabel.layout {
            $0.leading(to: leadingAnchor).top(to: topAnchor).trailing(to: trailingAnchor)
        }
        vstack.layout {
            $0.leading(to: leadingAnchor)
                .top(to: titleLabel.bottomAnchor, constant: 12)
                .trailing(to: trailingAnchor)
                .bottom(to: bottomAnchor)
        }
    }

    /// Panggil ini setiap kali ada data baru
    func update(title: String? = nil, items: [String]) {
        if let title { titleLabel.text = title }

        // bersihkan isi sebelumnya
        vstack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // isi ulang per 2 kolom
        var i = 0
        while i < items.count {
            let h = UIStackView()
            h.axis = .horizontal
            h.spacing = 24
            h.distribution = .fillEqually

            h.addArrangedSubview(facilityRow(items[i]))
            if i + 1 < items.count {
                h.addArrangedSubview(facilityRow(items[i + 1]))
            } else {
                h.addArrangedSubview(UIView())
            }
            vstack.addArrangedSubview(h)
            i += 2
        }
    }

    private func facilityRow(_ text: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center

        let icon = UIImageView(image: CocoIcon.icCheckMarkFill.image)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = Token.mainColorPrimary
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        icon.layout { $0.size(18) }

        let label = UILabel(
            font: .jakartaSans(forTextStyle: .subheadline, weight: .regular),
            textColor: Token.additionalColorsBlack,
            numberOfLines: 0
        )
        label.text = text

        row.addArrangedSubview(icon)
        row.addArrangedSubview(label)
        return row
    }
}

