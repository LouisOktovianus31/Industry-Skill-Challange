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
        thisView.onWhatsAppTapped = { [weak self] in

            // Ganti dengan link group WA asli dari backend kalau ada
            self?.open(urlString: "https://chat.whatsapp.com/HJSbMq9vWBS6WT3vLnieXE?mode=ems_copy_h_t")
        }
        thisView.action = self
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
    
    private func open(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func inviteTapped() {
        // pass
        print("Invite traveler tapped")
        
    }
    
    private let viewModel: TripDetailViewModelProtocol
    private let thisView: TripDetailView = TripDetailView()
    
    private var sheetNav: UINavigationController?
}

extension TripDetailViewController: TripDetailViewModelAction {
    func configureView(state: TripDetailViewState) {
        thisView.render(state)
        thisView.clearStatusView()
        
//        let style: CocoStatusLabelStyle = {
//            switch state.status.style.lowercased() {
//            case "success", "completed": return .success
//            case "refund":                 return .refund
//            case "pending":                return .pending
//            default:                       return .pending
//            }
//        }()
        
        let labelVC = CocoStatusLabelHostingController(
            title: state.status.text,
            style: state.status.style
        )
        addChild(labelVC)
        thisView.configureStatusLabelView(with: labelVC.view)
        labelVC.didMove(toParent: self)
    }
    
    func onAddCalendarDidTap() {
        viewModel.addEventCalendar()
    }
    
    func closeInviteTravelerView() {
        sheetNav?.dismiss(animated: true)
    }
    
    func configureFooter(viewModel: InviteTravelerViewModelProtocol) {
        let isShowFooter = self.viewModel.isShowFooterView()
        thisView.configureFooterView(isShowFooter)
        thisView.configureFooterViewAction {
            self.addTripMemberTapped(viewModel: viewModel)
        }
    }
    
    //    func configureView(dataModel: BookingDetailDataModel) {
    //        thisView.configureView(dataModel)
    //
    //        let labelVC: CocoStatusLabelHostingController = CocoStatusLabelHostingController(
    //            title: dataModel.status.text,
    //            style: dataModel.status.style
    //        )
    //        addChild(labelVC)
    //        thisView.configureStatusLabelView(with: labelVC.view)
    //        labelVC.didMove(toParent: self)
    //    }
    
    func openExternalURL(_ url: URL) {
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func addTripMemberTapped(viewModel: InviteTravelerViewModelProtocol) {
        let inviteTravellerViewController = InviteTravelerViewController(viewModel: viewModel)
        
        self.viewModel.updateInviteTravelerViewModel()
        
        inviteTravellerViewController.title = "Invite Traveler"
        sheetNav = UINavigationController(rootViewController: inviteTravellerViewController)
        sheetNav?.modalPresentationStyle = .pageSheet
        
        if let sheet = sheetNav?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        if let nav = sheetNav {
            present(nav, animated: true, completion: nil)
        }
    }
}
