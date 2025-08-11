//
//  CocoCalendarViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation
import UIKit

protocol CocoCalendarViewControllerDelegate: AnyObject {
    func notifyCalendarDidChooseDate(date: Date?, calendar: CocoCalendarViewController)
}

final class CocoCalendarViewController: UIViewController {
    weak var delegate: CocoCalendarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Token.additionalColorsWhite
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        
        let cancelButtonVC: CocoButtonHostingController = CocoButtonHostingController(
            action: { [weak self] in
                self?.applyTapped()
            },
            text: "Cancel",
            style: .normal,
            type: .tertiary,
            isStretch: true
        )
        
        let applyButtonVC: CocoButtonHostingController = CocoButtonHostingController(
            action: { [weak self] in
                guard let self else { return }
                self.applyTapped(completion: {
                    self.delegate?.notifyCalendarDidChooseDate(date: self.currentSelectedDate, calendar: self)
                })
            },
            text: "Apply",
            style: .normal,
            type: .primary,
            isStretch: true
        )
        
        addChild(cancelButtonVC)
        addChild(applyButtonVC)
        
        let buttonStackView: UIStackView = UIStackView(
            arrangedSubviews: [
                cancelButtonVC.view,
                applyButtonVC.view
            ]
        )
        cancelButtonVC.didMove(toParent: self)
        applyButtonVC.didMove(toParent: self)
        
        buttonStackView.spacing = 16
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [calendarView, buttonStackView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private lazy var calendarView: UICalendarView = createCalendarView()
    private lazy var currentSelectedDate: Date? = nil
}

extension CocoCalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        currentSelectedDate = dateComponents?.date
    }
}

private extension CocoCalendarViewController {
    func createCalendarView() -> UICalendarView {
        let calendarView: UICalendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        
        let dateSelection: UICalendarSelectionSingleDate = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        return calendarView
    }
    
    @objc func applyTapped(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}
