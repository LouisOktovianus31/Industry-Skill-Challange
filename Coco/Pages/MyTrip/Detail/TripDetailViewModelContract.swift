//
//  TripDetailViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation
import MapKit

protocol TripDetailViewModelAction: AnyObject {
//    func configureView(dataModel: BookingDetailDataModel)
    func configureView(state: TripDetailViewState)
    func openExternalURL(_ url: URL)
    func configureFooter(viewModel: InviteTravelerViewModelProtocol)
    func closeInviteTravelerView()
    func onAddCalendarDidTap()
}

protocol TripDetailViewModelProtocol: AnyObject {
    var actionDelegate: TripDetailViewModelAction? { get set }
    
    var invitesOutput: TripDetailInvitesOutput? { get set }
    func addTravelerDummy(name: String, email: String)
    func removeTraveler(id: UUID)
    func didTapLocation()
    func onViewDidLoad()
    func isShowFooterView() -> Bool
    func addEventCalendar()
    func updateInviteTravelerViewModel()
}

protocol TripDetailInvitesOutput: AnyObject {
    func didUpdateTravelers(_ travelers: [Traveler])
}

protocol MapOpener {
    func open(lat: Double, lon: Double, name: String)
}

struct DefaultMapOpener: MapOpener {
    func open(lat: Double, lon: Double, name: String) {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coord))
        item.name = name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coord),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:
                MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ])
    }
}
