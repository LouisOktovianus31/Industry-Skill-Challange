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
    
    init(data: TripBookingDetails) {
        self.data = data
        
        self.travelers = data.memberEmails.map { email in
            let name = email.components(separatedBy: "@").first?.replacingOccurrences(of: ".", with: " ") ?? "Traveller"
            return Traveler(name: name)
        }
    }
    
    private var data: TripBookingDetails?
    
    // Dummy Data
    //    private(set) var travelers: [Traveler] = [
    //            Traveler(name: "Jose L"),
    //            Traveler(name: "Lusi O"),
    //            Traveler(name: "Hany W"),
    //        ]
    
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
        if let data {                       // sudah ada data → langsung render
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
    }
}

// MARK: - Location logic (dipisah dari View)
extension TripDetailViewModel {
    func appleMapsURL(latitude: Double, longitude: Double, placeName: String) -> URL? {
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host   = "maps.apple.com"
        comps.path   = "/"                      // opsional, biar URL valid
        comps.queryItems = [
            URLQueryItem(name: "ll", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "q",  value: placeName)
        ]
        return comps.url
    }

    func didTapLocation() {
        let lat  = -0.233
        let long = 130.507
        guard let destinationName = data?.destinationName,
              let url = appleMapsURL(latitude: lat, longitude: long, placeName: destinationName)
        else { return }

        actionDelegate?.openExternalURL(url)
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
