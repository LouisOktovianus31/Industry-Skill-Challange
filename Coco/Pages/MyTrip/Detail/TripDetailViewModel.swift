//
//  TripDetailViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation
import EventKit
import MapKit

final class TripDetailViewModel {
    weak var actionDelegate: TripDetailViewModelAction?
    weak var invitesOutput: TripDetailInvitesOutput?
    
    init(data: TripBookingDetails) {
        self.data = data
        //        self.dataList = BookingDetails(trip: data)
        
        self.travelers = data.memberEmails.map { email in
            let name = email.components(separatedBy: "@").first?.replacingOccurrences(of: ".", with: " ") ?? "Traveller"
            return Traveler(name: name, email: email)
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
        let viewModel: InviteTravelerViewModel = InviteTravelerViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
}

extension TripDetailViewModel: InviteTravelerViewModelDelegate {
    func notifyInviteTravellerComplete() {
        actionDelegate?.closeInviteTravelerView()
        fetchData()
    }
}

private extension TripDetailViewModel {
    func fetchData() {
        guard let fetcher, let bookingId else { return }
        
        Task { @MainActor in
            do {
                let details = try await fetcher.fetchTripDetail(bookingId: bookingId)
                await MainActor.run {
                    data = details
                    travelers = details.memberEmails.map {
                        let name = $0.components(separatedBy: "@").first?.replacingOccurrences(of: ".", with: " ") ?? "Traveler"
                        return Traveler(name: name, email: $0)
                    }
                    updateInviteTravelerViewModel()
                    
                    actionDelegate?.configureFooter(viewModel: inviteTravelerViewModel)
                    actionDelegate?.configureView(dataModel: .init(trip: details))
                    invitesOutput?.didUpdateTravelers(travelers)
                }
            } catch {
                //print
            }
        }
    }
}

extension TripDetailViewModel: TripDetailViewModelProtocol {
    func updateInviteTravelerViewModel() {
        self.inviteTravelerViewModel.setData(self.data)
    }
    
    func addEventCalendar() {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted, error == nil else {
                print("Access denied: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = self.data?.activityTitle ?? "Coco Activity"
            event.startDate = self.data?.date
            event.endDate = event.startDate.addingTimeInterval(3600*24)
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
            } catch {
                print("Failed to save event: \(error.localizedDescription)")
            }
        }
    }
    
    func onViewDidLoad() {
        actionDelegate?.configureView(dataModel: BookingDetailDataModel(bookingDetail: dataList))
        
        if let data {
            actionDelegate?.configureView(dataModel: .init(trip: data))
            invitesOutput?.didUpdateTravelers(travelers)
            return
        }
        
        fetchData()
    }
    
    func isShowFooterView() -> Bool {
        guard let data else { return false }
        
        let today = Date()
        
        let isParticipantsMoreThanOne = data.participants > 1
        let isPlanner = true // todo update if BE complete
        let isUpcoming = data.date >= today
        
        return isParticipantsMoreThanOne && isPlanner && isUpcoming
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
    func addTravelerDummy(name: String, email: String) {
        travelers.append(Traveler(name: name, email: email))
        invitesOutput?.didUpdateTravelers(travelers)
        
    }
    
    func removeTraveler(id: UUID) {
        travelers.removeAll { $0.id == id }
        invitesOutput?.didUpdateTravelers(travelers)
    }
}
