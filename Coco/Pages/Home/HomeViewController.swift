//
//  HomeViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.actionDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
    
    override func loadView() {
        view = thisView
    }
    
    private let thisView: HomeView = HomeView()
    private let viewModel: HomeViewModelProtocol
}

extension HomeViewController: HomeViewModelAction {
    func constructCollectionView(viewModel: some HomeCollectionViewModelProtocol) {
        let collectionViewController: HomeCollectionViewController = HomeCollectionViewController(viewModel: viewModel)
        addChild(collectionViewController)
        thisView.addSearchResultView(from: collectionViewController.view)
        collectionViewController.didMove(toParent: self)
    }
    
    func constructLoadingState(state: HomeLoadingState) {
        let viewController: UIHostingController = UIHostingController(rootView: HomeLoadingView(state: state))
        addChild(viewController)
        thisView.addLoadingView(from: viewController.view)
        viewController.didMove(toParent: self)
        
        thisView.toggleLoadingView(isShown: true)
    }
    
    func constructNavBar(viewModel: HomeSearchBarViewModel) {
        let viewController: HomeSearchBarHostingController = HomeSearchBarHostingController(viewModel: viewModel)
        addChild(viewController)
        thisView.addSearchBarView(from: viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func toggleLoadingView(isShown: Bool, after: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: { [weak self] in
            guard let self else { return }
            self.thisView.toggleLoadingView(isShown: isShown)
        })
    }
    
    func activityDidSelect(data: ActivityDetailDataModel) {
        guard let navigationController else { return }
        let coordinator: HomeCoordinator = HomeCoordinator(
            input: .init(
                navigationController: navigationController,
                flow: .activityDetail(data: data)
            )
        )
        coordinator.parentCoordinator = AppCoordinator.shared
        coordinator.start()
    }
    
    func openSearchTray(
        selectedQuery: String,
        latestSearches: [HomeSearchSearchLocationData]
    ) {
        presentTray(view: HomeSearchSearchTray(
            selectedQuery: selectedQuery,
            latestSearches: latestSearches
        ) { [weak self] queryText in
            self?.dismiss(animated: true)
            self?.viewModel.onSearchDidApply(queryText)
        })
    }
    
    func openFilterTray(_ viewModel: HomeSearchFilterTrayViewModel) {
        presentTray(view: HomeSearchFilterTray(viewModel: viewModel))
    }
    
    func dismissTray() {
        dismiss(animated: true)
    }
}

private extension HomeViewController {
    func presentTray(view: some View) {
        let trayVC: UIHostingController = UIHostingController(rootView: view)
        if let sheet: UISheetPresentationController = trayVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.preferredCornerRadius = 32.0
        }
        present(trayVC, animated: true)
    }
}
