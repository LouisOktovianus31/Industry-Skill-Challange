//
//  CheckoutViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation
import SwiftUI
import UIKit

final class CheckoutViewController: UIViewController {
    init(viewModel: CheckoutViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.actionDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = thisView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        title = "Checkout"
    }
    
    private let viewModel: CheckoutViewModelProtocol
    private let thisView: CheckoutView = CheckoutView()
}

extension CheckoutViewController: CheckoutViewModelAction {
    func configureView(bookingData: BookingDetails) {
        thisView.configureView(bookingData)
        
        let bookButtonVC: CocoButtonHostingController = CocoButtonHostingController(
            action: viewModel.bookNowDidTap,
            text: "Book Now",
            style: .large,
            type: .primary,
            isStretch: true
        )
        addChild(bookButtonVC)
        thisView.addBooknowButton(from: bookButtonVC.view)
        bookButtonVC.didMove(toParent: self)
    }
    
    func showPopUpSuccess(completion: @escaping () -> Void) {
        let view: CheckoutCompletedPopUpView = CheckoutCompletedPopUpView { [weak self] in
            self?.dismiss(animated: true, completion: completion)
        }
        let hostingVC: UIHostingController = UIHostingController(rootView: view)
        let popUpVC = CocoPopupViewController(child: hostingVC)
        present(popUpVC, animated: true)
    }
}
