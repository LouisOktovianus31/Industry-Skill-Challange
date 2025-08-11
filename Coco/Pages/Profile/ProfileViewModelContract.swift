//
//  ProfileViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation

protocol ProfileViewModelAction: AnyObject {
    func showUserProfile(viewModel: UserProfileViewModel)
    func showSignInView(viewModel: SignInViewModel)
    func updateTitle(with text: String)
}

protocol ProfileViewModelProtocol: AnyObject {
    var actionDelegate: ProfileViewModelAction? { get set }
    
    func onViewDidLoad()
}
