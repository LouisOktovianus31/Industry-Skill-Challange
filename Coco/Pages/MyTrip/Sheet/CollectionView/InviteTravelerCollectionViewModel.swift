//
//  InviteTravelerCollectionViewModel.swift
//  Coco
//
//  Created by Arin Juan Sari on 20/08/25.
//

import Foundation

final class InviteTravelerCollectionViewModel {
    private(set) var emailTravelerListData: [Traveler] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    var onDataUpdated: (() -> Void)?
}

extension InviteTravelerCollectionViewModel: InviteTravellerCollectionViewModelProtocol {
    func onAddEmailTraveler(_ email: String) {
        emailTravelerListData.append(Traveler(name: nil, email: email))
    }
    
    func onRemoveEmailTraveler(at index: Int) {
        emailTravelerListData.remove(at: index)
    }
}
