//
//  HomeReusableHeader.swift
//  Coco
//
//  Created by Jackie Leonardy on 04/07/25.
//

import Foundation
import UIKit

final class HomeReusableHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String) {
        titleLabel.text = title
    }
    
    private lazy var titleLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .title3, weight: .semibold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 2
    )
}

private extension HomeReusableHeader {
    func setupView() {
        addSubviewAndLayout(titleLabel, insets: .init(top: 0, left: 0, bottom: 16.0,
                                                      right: 0))
    }
}
