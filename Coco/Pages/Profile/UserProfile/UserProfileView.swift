//
//  UserProfileView.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation
import UIKit

final class UserProfileView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addlogoutButton(with view: UIView) {
        logoutButtonContainer.subviews.forEach { $0.removeFromSuperview() }
        logoutButtonContainer.addSubviewAndLayout(view)
    }
    
    private lazy var logoutButtonContainer: UIView = UIView()
    private lazy var nameLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .subheadline, weight: .semibold),
        textColor: Token.additionalColorsBlack,
        numberOfLines: 0
    )
    private lazy var emailLabel: UILabel = UILabel(
        font: .jakartaSans(forTextStyle: .subheadline),
        textColor: Token.grayscale80,
        numberOfLines: 0
    )
}

private extension UserProfileView {
    func setupView() {
        let imageView: UIImageView = UIImageView()
        imageView.loadImage(from: URL(string: "https://picsum.photos/seed/dest-gili-t/800/600"))
        imageView.layout {
            $0.size(56.0)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 56.0 / 2
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            imageView,
            nameLabel,
            emailLabel
        ])
        stackView.spacing = 12.0
        stackView.axis = .vertical
        stackView.alignment = .center
        
        addSubviews([
            stackView,
            logoutButtonContainer
        ])
        
        stackView.layout {
            $0.top(to: self.safeAreaLayoutGuide.topAnchor, relation: .greaterThanOrEqual)
                .centerX(to: self.centerXAnchor)
                .centerY(to: self.centerYAnchor)
        }
        
        logoutButtonContainer.layout {
            $0.top(to: stackView.bottomAnchor, relation: .greaterThanOrEqual)
                .leading(to: self.leadingAnchor, constant: 26.0)
                .trailing(to: self.trailingAnchor, constant: -26.0)
                .bottom(to: self.safeAreaLayoutGuide.bottomAnchor, constant: -64.0)
        }
        
        nameLabel.text = UserDefaults.standard.string(forKey: "user-name") ?? ""
        emailLabel.text = UserDefaults.standard.string(forKey: "user-email") ?? ""
    }
}
