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
//            event.endDate = event.startDate.addingTimeInterval(3600*24)
            event.endDate = Calendar.current.date(byAdding: .day, value: 0, to: event.startDate)
            event.isAllDay = true
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
            } catch {
                print("Failed to save event: \(error.localizedDescription)")
            }
        }
    }
    
    func onViewDidLoad() {
        let state = makeState(from: data)
        actionDelegate?.configureView(state: state)
//        actionDelegate?.configureView(dataModel: BookingDetailDataModel(bookingDetail: dataList))
        
        if data != nil {
            actionDelegate?.configureView(state: state)
            invitesOutput?.didUpdateTravelers(travelers)
            return
        }        
        fetchData()
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
        guard let data else { return }
        let coord = CLLocationCoordinate2D(latitude: data.longitude, longitude: data.latitude)
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coord))
        item.name = data.destinationName
        item.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coord),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:
                MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ])
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
    
    private func makeState(from trip: TripBookingDetails?) -> TripDetailViewState {
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
            mapCoordinate: trip.map { .init(lat: $0.latitude, lon: $0.longitude, name: $0.destinationName) }
        )
    }
}
