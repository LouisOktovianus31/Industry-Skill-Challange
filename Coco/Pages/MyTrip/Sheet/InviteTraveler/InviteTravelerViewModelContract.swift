//
//  InviteTravelerContract.swift
//  Coco
//
//  Created by Arin Juan Sari on 19/08/25.
//

import Foundation

protocol InviteTravelerViewModelDelegate: AnyObject {
    func notifyInviteTravellerComplete()
}
protocol InviteTravelerViewModelAction: AnyObject {
    func configureInputEmailView(viewModel: HomeSearchBarViewModel)
    func configureListEmailView(viewModel: InviteTravellerCollectionViewModelProtocol)
    
    func onConfirmInviteTravelerDidTap()
    func setStateViewData(_ stateData: StateViewData?)
}
protocol InviteTravelerViewModelProtocol: AnyObject {
    var delegate: InviteTravelerViewModelDelegate? { get set }
    var action: InviteTravelerViewModelAction? { get set }
    
    func onInviteTravelerDidTap(_ email: String)
    func viewDidLoad()
    func setData(_ data: TripBookingDetails?)
    func sendInviteTravelerRequest() -> Task<Void, Never>
}
