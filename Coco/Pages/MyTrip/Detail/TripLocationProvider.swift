//
//  TripLocationProvider.swift
//  Coco
//
//  Created by Grachia Uliari on 20/08/25.
//

import Foundation
import CoreLocation
import MapKit

final class TripLocationProvider {
    static let shared = TripLocationProvider()
    private init() {}

    // Dummy database location
    private let db: [String: CLLocationCoordinate2D] = [
        "Raja Ampat, West Papua":  CLLocationCoordinate2D(latitude: -0.2346, longitude: 130.5070),
        "Gili Trawangan, Bali":    CLLocationCoordinate2D(latitude: -8.3510, longitude: 116.0370),
        "Bunaken, North Sulawesi": CLLocationCoordinate2D(latitude:  1.6264, longitude: 124.7594),
    ]

    func mapItem(for locationName: String) -> MKMapItem? {
        if let coord = db[locationName] {
            let placemark = MKPlacemark(coordinate: coord)
            let item = MKMapItem(placemark: placemark)
            item.name = locationName
            return item
        }
        return nil
    }

    func mapItem(for data: BookingDetailDataModel) -> MKMapItem? {
        return mapItem(for: data.location)
    }
}

