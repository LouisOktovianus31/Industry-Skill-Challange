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
    
    // MARK: Data
    private var data: TripBookingDetails?
    private var fetcher: TripDetailFetcherProtocol?
    private var bookingId: Int?
    
    private(set) var travelers: [Traveler] = []
    
    // MARK: Inits
    init(data: TripBookingDetails, mapOpener: MapOpener = DefaultMapOpener()) {
        self.data = data
        self.mapOpener = mapOpener
        self.travelers = data.memberEmails.map { email in
            let name = email.components(separatedBy: "@").first?.replacingOccurrences(of: ".", with: " ") ?? "Traveller"
            return Traveler(name: name, email: email)
        }
    }
    
    convenience init(bookingId: Int, fetcher: TripDetailFetcherProtocol = TripDetailFetcher(), mapOpener: MapOpener = DefaultMapOpener()) {
        self.init(data: nil, mapOpener: mapOpener)
        self.fetcher = fetcher
        self.bookingId = bookingId
    }
    
    private let mapOpener: MapOpener
    
    // private init untuk convenience init di atas
    private init(data: TripBookingDetails?, mapOpener: MapOpener) {
        self.data = data
        self.mapOpener = mapOpener
    }
    
    private(set) lazy var inviteTravelerViewModel: InviteTravelerViewModelProtocol = {
        let viewModel: InviteTravelerViewModel = InviteTravelerViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
    
}

// MARK: Public API (Protocol)
extension TripDetailViewModel: TripDetailViewModelProtocol {
    
    func onViewDidLoad() {
        let state = makeState(from: data)
        actionDelegate?.configureView(state: state)
        
        fetchData()
    }
    
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
    
    func isShowFooterView() -> Bool {
        guard let data else { return false }
        
        let today = Date()
        
        let isParticipantsMoreThanOne = data.participants > 1
        
        print("data.date:\(data.date)")
        let isPlanner = data.isPlanner
        
        let isUpcoming = data.date >= today
        
        return isParticipantsMoreThanOne && isPlanner && isUpcoming
    }
}


extension TripDetailViewModel: InviteTravelerViewModelDelegate {
    func notifyInviteTravellerComplete() {
        actionDelegate?.closeInviteTravelerView()
        fetchData()
    }
}

// MARK: - Networking
private extension TripDetailViewModel {
    func fetchData() {
        guard let fetcher, let bookingId else { return }
        
        Task { [weak self] in
            do {
                let details = try await fetcher.fetchTripDetail(bookingId: bookingId)
                
                await MainActor.run {
                    guard let self else { return }
                    
                    // simpan data dulu karena makeState() butuh self.data untuk hitung showFooter, dll
                    self.data = details
                    
                    // sinkronkan travelers
                    self.travelers = details.memberEmails.map {
                        let name = $0
                            .components(separatedBy: "@").first?
                            .replacingOccurrences(of: ".", with: " ") ?? "Traveler"
                        return Traveler(name: name, email: $0)
                    }
                    
                    // update VM bagian undangan
                    self.updateInviteTravelerViewModel()
                    
                    // bangun state dari data terbaru
                    let state = self.makeState(from: details)
                    
                    // kirim ke View
                    self.actionDelegate?.configureView(state: state)
                    self.actionDelegate?.configureFooter(viewModel: self.inviteTravelerViewModel)
                    
                    // update daftar traveler (untuk section Travelers)
                    self.invitesOutput?.didUpdateTravelers(self.travelers)
                }
            } catch {
                print("TripDetail fetch error:", error)
            }
        }
    }
    
    func makeState(from trip: TripBookingDetails?) -> TripDetailViewState {
        let title = trip?.activityTitle ?? ""
        let imageURL = URL(string: trip?.destinationImage ?? "")
        let cal = Calendar(identifier: .gregorian)
        let today = cal.startOfDay(for: Date())
        let day   = cal.startOfDay(for: trip?.date ?? Date())
        
        let statusText: String
        let statusStyle: CocoStatusLabelStyle
        if day < today {
            statusText  = "Completed"
            statusStyle = .success
        } else if day > today {
            statusText  = "Upcoming"
            statusStyle = .refund
        } else {
            statusText  = "Today"
            statusStyle = .refund
        }
        
        return TripDetailViewState(
            imageURL: imageURL,
            title: title,
            locationText: trip?.destinationName ?? "",
            dateText: Formatters.tripDateDisplay.string(from: trip?.date ?? Date()),
            paxText: "\(trip?.participants ?? 0) person",
            plannerName: trip?.plannerName ?? "",
            status: .init(text: statusText, style: statusStyle),
            packageName: trip?.packageName ?? "",
            priceText: Formatters.idr((trip?.totalPrice as NSDecimalNumber?)?.doubleValue ?? 0),
            addressText: trip?.destinationName ?? "",
            vendorName: trip?.vendorName ?? "",
            vendorContact: trip?.vendorContact ?? "",
            includedAccessories: trip?.includedAccessories ?? [],
            facilities: trip?.includedAccessories ?? [],
            showFacilities: !(trip?.includedAccessories.isEmpty ?? true),
            showFooter: isShowFooterView(),
            qrTitle: "View QR Code",
            qrPayload: "booking:\(trip?.bookingId ?? 0)",
            waTitle: "Join the Trip WhatsApp Community",
            mapCoordinate: trip.map { .init(lat: $0.feLatitude, lon: $0.feLongitude, name: $0.destinationName) }
        )
    }
}

// MARK: - Location logic
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
        guard let data else { return }
        mapOpener.open(lat: data.feLatitude, lon: data.feLongitude, name: data.destinationName)
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
