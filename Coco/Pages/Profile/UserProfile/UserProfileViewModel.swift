//
//  UserProfileViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation

final class UserProfileViewModel {
    weak var delegate: (any UserProfileViewModelDelegate)?
    weak var actionDelegate: (any UserProfileViewModelAction)?
}

extension UserProfileViewModel: UserProfileViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.configureView()
    }
    
    func onLogoutDidTap() {
        delegate?.notifyUserDidLogout()
    }
}
