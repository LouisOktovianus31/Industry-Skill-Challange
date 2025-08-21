//
//  InviteTravelerCollectionViewModel.swift
//  Coco
//
//  Created by Arin Juan Sari on 20/08/25.
//

import Foundation

final class InviteTravelerCollectionViewModel {
    private(set) var emailTravelerListData: [InviteTravelerCellDataModel] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    var onDataUpdated: (() -> Void)?
}

extension InviteTravelerCollectionViewModel: InviteTravellerCollectionViewModelProtocol {
    func onAddEmailTraveler(_ email: String, data: BookingDetails) {
        print("data\(data)")
        guard email.contains("@") else {
            print("Invalid email: must contain '@'")
            return
        }
        
        guard !emailTravelerListData.contains(where: { $0.email.lowercased() == email.lowercased() }) else {
            print("Email already exists in the list")
            return
        }
        
        guard emailTravelerListData.count < data.participants else {
            print("Cannot add more travelers. Participants: \(data.participants)")
            return
        }
        
        emailTravelerListData.append(InviteTravelerCellDataModel(email: email))
    }
    
    func onRemoveEmailTraveler(at index: Int) {
        emailTravelerListData.remove(at: index)
    }
}
