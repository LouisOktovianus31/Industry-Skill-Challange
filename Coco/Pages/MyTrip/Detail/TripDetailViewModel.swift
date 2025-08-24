//
//  TripDetailViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation
import MapKit

final class TripDetailViewModel {
    weak var actionDelegate: TripDetailViewModelAction?
    weak var invitesOutput: TripDetailInvitesOutput?
    
    init(data: TripBookingDetails) {
        self.data = data
        //        self.dataList = BookingDetails(trip: data)
        
        self.travelers = data.memberEmails.map { email in
            let name = email.components(separatedBy: "@").first?.replacingOccurrences(of: ".", with: " ") ?? "Traveller"
            return Traveler(name: name)
        }
    }
    
    private var data: TripBookingDetails?

    private(set) var travelers: [Traveler] = []
    private var fetcher: TripDetailFetcherProtocol?
    private var bookingId: Int?
    
    convenience init(bookingId: Int, fetcher: TripDetailFetcherProtocol = TripDetailFetcher()) {
        self.init(data: nil)
        self.fetcher = fetcher
        self.bookingId = bookingId
    }
    
    // private init untuk convenience init di atas
    private init(data: TripBookingDetails?) {
        self.data = data
        
    }
    //    private let dataList: BookingDetails
    private lazy var dataList: BookingDetails = {
        guard let data = data else { return .empty }
        return BookingDetails(trip: data)
    }()

    
    private(set) lazy var inviteTravelerViewModel: InviteTravelerViewModelProtocol = {
        let viewModel: InviteTravelerViewModel = InviteTravelerViewModel(data: dataList)
        //        viewModel.delegate = self
        
        return viewModel
    }()

}

//extension TripDetailViewModel: TripDetailViewModelProtocol {
//    func onViewDidLoad() {
//        //        actionDelegate?.configureView(dataModel: BookingDetailDataModel(bookingDetail: data))
//        actionDelegate?.configureView(dataModel: BookingDetailDataModel(trip: data))
//        invitesOutput?.didUpdateTravelers(travelers) // initial travelers payload
//    }
//}

extension TripDetailViewModel: TripDetailViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.configureView(dataModel: BookingDetailDataModel(bookingDetail: dataList))
        actionDelegate?.configureFooter(viewModel: inviteTravelerViewModel)
        
        if let data {
            actionDelegate?.configureView(dataModel: .init(trip: data))
            invitesOutput?.didUpdateTravelers(travelers)
            return
        }
        
        // kalau dibuat via bookingId → fetch dulu
        guard let fetcher, let bookingId else { return }
        
        Task { [weak self] in
            do {
                let details = try await fetcher.fetchTripDetail(bookingId: bookingId)
                await MainActor.run {
                    self?.data = details
                    self?.travelers = details.memberEmails.map {
                        let name = $0.components(separatedBy: "@").first?.replacingOccurrences(of: ".", with: " ") ?? "Traveler"
                        return Traveler(name: name)
                    }
                    self?.actionDelegate?.configureView(dataModel: .init(trip: details))
                    self?.invitesOutput?.didUpdateTravelers(self?.travelers ?? [])
                }
            } catch {
                // TODO: tampilkan error state bila perlu
                print("TripDetail fetch error:", error)
            }
        }
        
        //        invitesOutput?.didUpdateTravelers(travelers) // initial travelers payload
    }
}

// MARK: - Location logic (dipisah dari View)
extension TripDetailViewModel {
    private func openInAppleMaps(lat: Double, lon: Double, name: String) {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coord))
        item.name = name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coord),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:
                MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ])
    }
    
    func didTapLocation() {
        guard let data = data else { return }
        openInAppleMaps(
            lat: data.latitude,
            lon: data.longitude,
            name: data.destinationName
        )
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
