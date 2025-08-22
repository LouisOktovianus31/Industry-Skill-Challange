//
//  TripDetailViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation
import UIKit
import MapKit

final class TripDetailViewController: UIViewController, TripDetailInvitesOutput {
    
    init(viewModel: TripDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.actionDelegate = self
        self.viewModel.invitesOutput = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didUpdateTravelers(_ travelers: [Traveler]) {
        thisView.renderTravelers(travelers)
    }
    
    override func loadView() {
        view = thisView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trip Space"
        
        thisView.onLocationTapped = { [weak self] in
                self?.viewModel.didTapLocation()
            }
        viewModel.onViewDidLoad()
    }
    
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
    
    @objc private func inviteTapped() {
        // pass
        print("Invite traveler tapped")
        
    }
    
//    @objc private func locationButtonTapped() {
//        viewModel.didTapLocation()
//    }
    
    private let viewModel: TripDetailViewModelProtocol
    private let thisView: TripDetailView = TripDetailView()
}

extension TripDetailViewController: TripDetailViewModelAction {
    func configureFooter(viewModel: InviteTravelerViewModelProtocol) {
        thisView.configureFooterViewAction {
            self.addTripMemberTapped(viewModel: viewModel)
        }
    }
    
    func configureView(dataModel: BookingDetailDataModel) {
        thisView.configureView(dataModel)
        
        let labelVC: CocoStatusLabelHostingController = CocoStatusLabelHostingController(
            title: dataModel.status.text,
            style: dataModel.status.style
        )
        addChild(labelVC)
        thisView.configureStatusLabelView(with: labelVC.view)
        labelVC.didMove(toParent: self)
    }
    

    func openExternalURL(_ url: URL) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

    private func addTripMemberTapped(viewModel: InviteTravelerViewModelProtocol) {
        let inviteTravellerViewController = InviteTravelerViewController(viewModel: viewModel)
        inviteTravellerViewController.title = "Invite Traveler"
        let nav = UINavigationController(rootViewController: inviteTravellerViewController)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(nav, animated: true, completion: nil)
    }

}
