//
//  UserProfileViewModelDelegate.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation

protocol UserProfileViewModelDelegate: AnyObject {
    func notifyUserDidLogout()
}

protocol UserProfileViewModelAction: AnyObject {
    func configureView()
}

protocol UserProfileViewModelProtocol: AnyObject {
    var delegate: UserProfileViewModelDelegate? { get set }
    var actionDelegate: UserProfileViewModelAction? { get set }
    
    func onViewDidLoad()
    func onLogoutDidTap()
}
