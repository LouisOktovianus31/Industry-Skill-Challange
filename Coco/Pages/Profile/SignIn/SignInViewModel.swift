//
//  SignInViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 15/07/25.
//

import Foundation

final class SignInViewModel {
    weak var delegate: (any SignInViewModelDelegate)?
    weak var actionDelegate: (any SignInViewModelAction)?
    
    init(fetcher: SignInFetcherProtocol = SignInFetcher()) {
        self.fetcher = fetcher
    }

    private lazy var emailInputVM: HomeSearchBarViewModel = HomeSearchBarViewModel(
        leadingIcon: nil,
        placeholderText: "Enter your email address",
        currentTypedText: "",
        trailingIcon: nil,
        isTypeAble: true,
        delegate: nil
    )
    
    private lazy var passwordInputVM: CocoSecureInputTextFieldViewModel = CocoSecureInputTextFieldViewModel(
        leadingIcon: nil,
        placeholderText: "Enter your password",
        currentTypedText: ""
    )
    
    private let fetcher: SignInFetcherProtocol
}

extension SignInViewModel: SignInViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.configureView(
            emailInputVM: emailInputVM,
            passwordInputVM: passwordInputVM
        )
    }
    
    func onSignInDidTap() {
        fetcher.signIn(
            spec: SignInSpec(
                email: emailInputVM.currentTypedText,
                password: passwordInputVM.currentTypedText
            )
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                delegate?.notifySignInDidSuccess()
                UserDefaults.standard.setValue(success.userId, forKey: "user-id")
                UserDefaults.standard.setValue(success.name, forKey: "user-name")
                UserDefaults.standard.setValue(success.email, forKey: "user-email")
            case .failure(let failure):
                break
            }
        }
    }
}
