//
//  ProfileViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 15/07/25.
//

import Foundation

final class ProfileViewModel: ProfileViewModelProtocol {
    weak var actionDelegate: ProfileViewModelAction?
}

extension ProfileViewModel {
    func onViewDidLoad() {
        if let _: String = UserDefaults.standard.value(forKey: "user-id") as? String {
            showUserProfileView()
        }
        else {
            showSignInView()
        }
    }
}

extension ProfileViewModel: SignInViewModelDelegate {
    func notifySignInDidSuccess() {
        showUserProfileView()
    }
}

extension ProfileViewModel: UserProfileViewModelDelegate {
    func notifyUserDidLogout() {
        UserDefaults.standard.removeObject(forKey: "user-id")
        showSignInView()
    }
}

private extension ProfileViewModel {
    func showSignInView() {
        let viewModel: SignInViewModel = SignInViewModel()
        viewModel.delegate = self
        actionDelegate?.showSignInView(viewModel: viewModel)
        actionDelegate?.updateTitle(with: "Sign In")
    }
    
    func showUserProfileView() {
        let viewModel: UserProfileViewModel = UserProfileViewModel()
        viewModel.delegate = self
        actionDelegate?.showUserProfile(viewModel: viewModel)
        actionDelegate?.updateTitle(with: "Settings")
    }
}
