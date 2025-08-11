//
//  SignInViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 15/07/25.
//

import Foundation

protocol SignInViewModelDelegate: AnyObject {
    func notifySignInDidSuccess()
}

protocol SignInViewModelAction: AnyObject {
    func configureView(
        emailInputVM: HomeSearchBarViewModel,
        passwordInputVM: CocoSecureInputTextFieldViewModel
    )
}

protocol SignInViewModelProtocol: AnyObject {
    var delegate: SignInViewModelDelegate? { get set }
    var actionDelegate: SignInViewModelAction? { get set }
    
    func onViewDidLoad()
    func onSignInDidTap()
}
