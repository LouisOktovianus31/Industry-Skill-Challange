//
//  InviteTravelerView.swift
//  Coco
//
//  Created by Arin Juan Sari on 19/08/25.
//

import Foundation
import UIKit

final class InviteTravelerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEmailListView(from view: UIView) {
        emailListView.subviews.forEach { $0.removeFromSuperview() }
        emailListView.addSubviewAndLayout(view)
    }
    
    func addInputEmailView(from view: UIView) {
        inputEmailView.subviews.forEach { $0.removeFromSuperview() }
        inputEmailView.addSubviewAndLayout(view)
    }
    
    func setStateViewData(_ stateData: StateViewData? = nil) {
        if let data = stateData {
            stateView.setData(data)
            stateView.isHidden = false
        } else {
            stateView.isHidden = true
        }
    }
    
    private lazy var inviteButtonContainer: CocoButtonHostingController = CocoButtonHostingController(
        action: { [weak self] in
            guard let self else { return }
            action?.onConfirmInviteTravelerDidTap()
        },
        text: "Confirm",
        style: .normal,
        type: .primary,
        isStretch: true
    )
    private lazy var inputEmailView: UIView = UIView()
    private lazy var emailListView: UIView = UIView()
    private lazy var stateView: StateView = StateView()
    
    weak var action: InviteTravelerViewModelAction?
}

private extension InviteTravelerView {
    func setupViews() {
        backgroundColor = Token.additionalColorsWhite
        stateView.isHidden = true
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [inputEmailView, emailListView, stateView, inviteButtonContainer.view])
        
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
