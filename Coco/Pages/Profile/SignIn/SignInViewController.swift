//
//  SignInViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 15/07/25.
//

import Foundation
import UIKit

final class SignInViewController: UIViewController {
    init(viewModel: SignInViewModelProtocol) {
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
        
        title = "Sign in"
    }
    
    override func loadView() {
        view = thisView
    }
    
    private let viewModel: SignInViewModelProtocol
    private let thisView: SignInView = SignInView()
}

extension SignInViewController: SignInViewModelAction {
    func configureView(
        emailInputVM: HomeSearchBarViewModel,
        passwordInputVM: CocoSecureInputTextFieldViewModel
    ) {
        let emailInputVC: HomeSearchBarHostingController = HomeSearchBarHostingController(viewModel: emailInputVM)
        addChild(emailInputVC)
       
        
        let passwordInputVC: CocoSecureInputTextFieldHostingController = CocoSecureInputTextFieldHostingController(viewModel: passwordInputVM)
        addChild(passwordInputVC)
        
        thisView.configureInputView(datas: [
            ("Email Address", emailInputVC.view),
            ("Password", passwordInputVC.view)
        ])
        
        emailInputVC.didMove(toParent: self)
        passwordInputVC.didMove(toParent: self)
        
        let buttonHostingVC: CocoButtonHostingController = CocoButtonHostingController(
            action: { [weak self] in
                self?.viewModel.onSignInDidTap()
            },
            text: "Sign in",
            style: .large,
            type: .primary
        )
        
        addChild(buttonHostingVC)
        thisView.addActionButton(with: buttonHostingVC.view)
        buttonHostingVC.didMove(toParent: self)
    }
}
