//
//  InviteTravelerViewController.swift
//  Coco
//
//  Created by Arin Juan Sari on 19/08/25.
//

import UIKit
import SwiftUI

class InviteTravelerViewController: UIViewController {
    private let viewModel: InviteTravelerViewModelProtocol
    private let thisView: InviteTravelerView = InviteTravelerView()
    
    init(viewModel: InviteTravelerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.viewDidLoad()
        thisView.action = self
    }
    
    override func loadView() {
        view = thisView
    }
}

extension InviteTravelerViewController: InviteTravelerViewModelAction {
    func setStateViewData(_ stateData: StateViewData?) {
        thisView.setStateViewData(stateData)
    }
    
    func onConfirmInviteTravelerDidTap() {
        viewModel.sendInviteTravelerRequest()
    }
    
    func configureInputEmailView(viewModel: HomeSearchBarViewModel) {
        let inputVC: UIHostingController = UIHostingController(
            rootView: HomeSearchBarView(
                viewModel: viewModel
            )
        )
        addChild(inputVC)
        thisView.addInputEmailView(from: inputVC.view)
        inputVC.didMove(toParent: self)
    }
    
    func configureListEmailView(viewModel: any InviteTravellerCollectionViewModelProtocol) {
        let collectionViewController: InviteTravelerCollectionViewController = InviteTravelerCollectionViewController(viewModel: viewModel)
        addChild(collectionViewController)
        thisView.addEmailListView(from: collectionViewController.view)
        collectionViewController.didMove(toParent: self)
    }
}
