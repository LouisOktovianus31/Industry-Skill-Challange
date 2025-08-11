//
//  UserProfileViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation
import UIKit

final class UserProfileViewController: UIViewController {
    init(viewModel: UserProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.actionDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
    
    override func loadView() {
        view = thisView
    }
    
    private let viewModel: UserProfileViewModelProtocol
    private let thisView: UserProfileView = UserProfileView()
}

extension UserProfileViewController: UserProfileViewModelAction {
    func configureView() {
        let buttonHosting: CocoButtonHostingController = CocoButtonHostingController(
            action: { [weak self] in
                self?.viewModel.onLogoutDidTap()
            },
            text: "Log out",
            style: .large,
            type: .secondary,
            isStretch: true
        )
        
        addChild(buttonHosting)
        thisView.addlogoutButton(with: buttonHosting.view)
        buttonHosting.didMove(toParent: self)
    }
}
