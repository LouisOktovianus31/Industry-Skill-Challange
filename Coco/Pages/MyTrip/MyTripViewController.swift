//
//  MyTripViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import UIKit

final class MyTripViewController: UIViewController {
    init(viewModel: MyTripViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.actionDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Trip"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        thisView.initMyTripTabView(action: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storedFilterIndex = viewModel.getCurrentFilter() == .upcoming ? 0 : 1
        
        thisView.setSegmentIndex(storedFilterIndex)
        
        viewModel.onViewWillAppear()
    }
    
    override func loadView() {
        view = thisView
    }
    
    private let viewModel: MyTripViewModelProtocol
    private let thisView: MyTripView = MyTripView()
}

extension MyTripViewController: MyTripViewModelAction {
    func setStateViewData(_ stateData: StateViewData?) {
        thisView.setStateViewData(stateData)
    }
    
    func goToRebookingDetail(with data: BookingDetails) {
        guard let navigationController else { return }
        let coordinator: MyTripCoordinator = MyTripCoordinator(
            input: .init(
                navigationController: navigationController,
                flow: .rebookingDetail(data: data)
            )
        )
        coordinator.parentCoordinator = AppCoordinator.shared
        coordinator.start()
    }
    
    func contructCollectionView(viewModel: MyTripListCollectionViewModelProtocol) {
        let collectionViewController: MyTripListCollectionViewController = MyTripListCollectionViewController(viewModel: viewModel)
        addChild(collectionViewController)
        thisView.addMyTripListView(from: collectionViewController.view)
        collectionViewController.didMove(toParent: self)
    }
    
    func goToBookingDetail(with data: BookingDetails) {
        guard let navigationController else { return }
        let coordinator: MyTripCoordinator = MyTripCoordinator(
            input: .init(
                navigationController: navigationController,
                flow: .bookingDetail(data: data)
            )
        )
        coordinator.parentCoordinator = AppCoordinator.shared
        coordinator.start()
    }
    
    func segmentDidChange(to index: Int) {
        let filter: EventFilter = index == 0 ? .upcoming : .history
        viewModel.changeFilter(to: filter)
    }
}
