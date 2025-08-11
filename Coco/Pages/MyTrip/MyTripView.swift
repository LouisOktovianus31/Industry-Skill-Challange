//
//  MyTripView.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation
import UIKit

protocol MyTripViewDelegate: MyTripListCardViewDelegate { }

final class MyTripView: UIView {
    weak var delegate: MyTripViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(datas: [MyTripListCardDataModel]) {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        datas.enumerated().forEach { (index, data) in
            let view: MyTripListCardView = MyTripListCardView()
            view.delegate = delegate
            view.configureView(dataModel: data, index: index)
            contentStackView.addArrangedSubview(view)
        }
    }
    
    private lazy var contentStackView: UIStackView = createStackView()
}

private extension MyTripView {
    func setupView() {
        backgroundColor = Token.additionalColorsWhite
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubviewAndLayout(contentStackView)
        contentStackView.layout {
            $0.widthAnchor(to: scrollView.widthAnchor)
        }
        
        addSubviewAndLayout(scrollView, insets: UIEdgeInsets(edges: 21.0))
    }
    
    func createStackView() -> UIStackView {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        return stackView
    }
}
