//
//  TripDetailViewState.swift
//  Coco
//
//  Created by Grachia Uliari on 25/08/25.
//
import Foundation

struct TripDetailViewState: Equatable {
    struct Status: Equatable {
        let text: String
        let style: CocoStatusLabelStyle
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.text == rhs.text
        }
    }
    
    struct Vendor: Equatable {
        let name: String
        let email: String
        let phone: String
    }
    
    struct Coordinates: Equatable {
        let lat: Double
        let lon: Double
        let name: String
    }
    
    let imageURL: URL?
    let title: String
    let locationText: String
    let dateText: String
    let paxText: String
    let plannerName: String
    
    // badge/status
    //    struct Status { let text: String; let style: CocoStatusLabelStyle }
    //    let statusText: String
    //    let statusStyle: CocoStatusLabelStyle
    let status: Status
    
    // package & price
    let packageName: String
    let priceText: String
    
    // meeting point & vendor
    let addressText: String
    let vendorName: String
    let vendorContact: String
    //    struct Vendor { let name: String; let email: String; let phone: String }
    
    // lists
    let includedAccessories: [String]
    let facilities: [String] // jika mau disatukan
    
    // sections visibility
    let showFacilities: Bool
    let showFooter: Bool
    
    // actions payload
    let qrTitle: String
    let qrPayload: String
    let waTitle: String
    let mapCoordinate: Coordinates?
}
