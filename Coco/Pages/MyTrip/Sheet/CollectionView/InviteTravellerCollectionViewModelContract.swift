//
//  InviteTravellerCollectionViewModelContract.swift
//  Coco
//
//  Created by Arin Juan Sari on 20/08/25.
//

import Foundation

protocol InviteTravellerCollectionViewModelProtocol: AnyObject {
    var emailTravelerListData: [Traveler] { get }
    var onDataUpdated: (() -> Void)? { get set }
    
    func onRemoveEmailTraveler(at index: Int)
    func onAddEmailTraveler(_ email: String)
}
