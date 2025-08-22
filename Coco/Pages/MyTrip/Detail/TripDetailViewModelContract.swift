//
//  TripDetailViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation

protocol TripDetailViewModelAction: AnyObject {
    func configureView(dataModel: BookingDetailDataModel)
    func openExternalURL(_ url: URL)
    func configureFooter(viewModel: InviteTravelerViewModelProtocol)
}

protocol TripDetailViewModelProtocol: AnyObject {
    var actionDelegate: TripDetailViewModelAction? { get set }
    
    var invitesOutput: TripDetailInvitesOutput? { get set }
    func addTravelerDummy(name: String)
    func removeTraveler(id: UUID)
    func didTapLocation()
    func onViewDidLoad()
    
}

protocol TripDetailInvitesOutput: AnyObject {
    func didUpdateTravelers(_ travelers: [Traveler])
}
