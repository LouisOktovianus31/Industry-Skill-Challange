//
//  SignInView.swift
//  Coco
//
//  Created by Jackie Leonardy on 15/07/25.
//

import Foundation
import UIKit

final class SignInView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureInputView(datas: [(title: String, view: UIView)]) {
        inputStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        datas.forEach { (title, view) in
            inputStackView.addArrangedSubview(
                createInputContainerView(
                    title: title,
                    view: view
                )
            )
        }
    }
    
    func addActionButton(with view: UIView) {
        actionButtonContainerView.subviews.forEach { $0.removeFromSuperview() }
        actionButtonContainerView.addSubviewAndLayout(view)
    }
    
    private lazy var inputStackView: UIStackView = createStackView()
    private lazy var actionButtonContainerView: UIView = UIView()
}

private extension SignInView {
    func setupView() {
        let contentView: UIView = UIView()
        contentView.addSubviews([
            inputStackView,
            actionButtonContainerView
        ])
        
        inputStackView.layout {
            $0.top(to: contentView.topAnchor)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
        }
        
        actionButtonContainerView.layout {
            $0.top(to: inputStackView.bottomAnchor, constant: 32.0)
                .leading(to: contentView.leadingAnchor)
                .trailing(to: contentView.trailingAnchor)
                .bottom(to: contentView.bottomAnchor)
        }
        
        addSubview(contentView)
        contentView.layout {
            $0.top(to: self.safeAreaLayoutGuide.topAnchor, constant: 24.0)
                .leading(to: self.leadingAnchor, constant: 24.0)
                .trailing(to: self.trailingAnchor, constant: -24.0)
                .bottom(to: self.bottomAnchor, relation: .lessThanOrEqual, constant: -24.0)
        }
    }
    
    func createStackView() -> UIStackView {
        let stackView: UIStackView = UIStackView()
        stackView.spacing = 16.0
        stackView.axis = .vertical
        
        return stackView
    }
    
    func createInputContainerView(title: String, view: UIView) -> UIView {
        let containerView: UIView = UIView()
        let titleLabel: UILabel = UILabel()
        titleLabel.text = title
        
        containerView.addSubviews([titleLabel, view])
        titleLabel.layout {
            $0.top(to: containerView.topAnchor)
                .leading(to: containerView.leadingAnchor)
                .trailing(to: containerView.trailingAnchor)
        }
        
        view.layout {
            $0.top(to: titleLabel.bottomAnchor, constant: 8.0)
                .leading(to: containerView.leadingAnchor)
                .trailing(to: containerView.trailingAnchor)
                .bottom(to: containerView.bottomAnchor)
        }
        
        return containerView
    }
}
