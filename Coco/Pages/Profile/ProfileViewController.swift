//
//  ProfileViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    init(viewModel: ProfileViewModelProtocol) {
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
    
    private let viewModel: ProfileViewModelProtocol
    private var currentChild: UIViewController?
}

extension ProfileViewController: ProfileViewModelAction {
    func showUserProfile(viewModel: UserProfileViewModel) {
        let vc: UserProfileViewController = UserProfileViewController(viewModel: viewModel)
        switchToChild(vc)
    }
    
    func showSignInView(viewModel: SignInViewModel) {
        let viewController: SignInViewController = SignInViewController(viewModel: viewModel)
        switchToChild(viewController)
    }
    
    func updateTitle(with text: String) {
        title = text
    }
}

private extension ProfileViewController {
    private func switchToChild(_ newChild: UIViewController) {
        // Remove old child if present
        if let current: UIViewController = currentChild {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }

        // Add new child
        addChild(newChild)
        view.addSubviewAndLayout(newChild.view)
        newChild.didMove(toParent: self)

        // Track it

        currentChild = newChild
   }
}
