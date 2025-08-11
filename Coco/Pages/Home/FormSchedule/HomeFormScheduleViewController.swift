//
//  HomeFormScheduleViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation
import SwiftUI
import UIKit

final class HomeFormScheduleViewController: UIViewController {
    init(viewModel: HomeFormScheduleViewModelProtocol) {
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
        title = "Form Schedule"
    }
    
    private let viewModel: HomeFormScheduleViewModelProtocol
    private let thisView: HomeFormScheduleView = HomeFormScheduleView()
}

extension HomeFormScheduleViewController: HomeFormScheduleViewModelAction {
    func setupView(
        calendarViewModel: HomeSearchBarViewModel,
        paxInputViewModel: HomeSearchBarViewModel
    ) {
        let inputVC: UIHostingController = UIHostingController(
            rootView: HomeFormScheduleInputView(
                calendarViewModel: calendarViewModel,
                paxInputViewModel: paxInputViewModel,
                actionButtonAction: { [weak self] in
                    self?.viewModel.onCheckout()
                }
            )
        )
        addChild(inputVC)
        thisView.addInputView(from: inputVC.view)
        inputVC.didMove(toParent: self)
    }
    
    func configureView(data: HomeFormScheduleViewData) {
        thisView.configureView(data: data)
    }
    
    func showCalendarOption() {
        let calendarVC: CocoCalendarViewController = CocoCalendarViewController()
        calendarVC.delegate = self
        let popup: CocoPopupViewController = CocoPopupViewController(child: calendarVC)
        present(popup, animated: true)
    }
}

extension HomeFormScheduleViewController: CocoCalendarViewControllerDelegate {
    func notifyCalendarDidChooseDate(date: Date?, calendar: CocoCalendarViewController) {
        guard let date: Date else { return }
        viewModel.onCalendarDidChoose(date: date)
    }
}
