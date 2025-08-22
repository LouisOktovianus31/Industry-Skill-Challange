//
//  TripDetailViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation

final class TripDetailViewModel {
    weak var actionDelegate: TripDetailViewModelAction?
    weak var invitesOutput: TripDetailInvitesOutput?
    
    init(data: BookingDetails) {
        self.data = data
    }
    
    private let data: BookingDetails
    
    // Dummy Data
    private(set) var travelers: [Traveler] = [
        Traveler(name: "Jose L"),
        Traveler(name: "Lusi O"),
        Traveler(name: "Hany W"),
    ]
    
    private(set) lazy var inviteTravelerViewModel: InviteTravelerViewModelProtocol = {
        let viewModel: InviteTravelerViewModel = InviteTravelerViewModel(data: data)
//        viewModel.delegate = self
        
        return viewModel
    }()
}

extension TripDetailViewModel: TripDetailViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.configureView(dataModel: BookingDetailDataModel(bookingDetail: data))
        actionDelegate?.configureFooter(viewModel: inviteTravelerViewModel)
        invitesOutput?.didUpdateTravelers(travelers) // initial travelers payload
    }
}

// MARK: - Actions (dummy for now)
extension TripDetailViewModel {
    func addTravelerDummy(name: String) {
        travelers.append(Traveler(name: name))
        invitesOutput?.didUpdateTravelers(travelers)
    }
    
    func removeTraveler(id: UUID) {
        travelers.removeAll { $0.id == id }
        invitesOutput?.didUpdateTravelers(travelers)
    }
}
