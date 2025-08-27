//
//  MyTripView.swift
//  Coco
//
//  Created by Jackie Leonardy on 14/07/25.
//

import Foundation
import UIKit


final class MyTripView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMyTripListView(from view: UIView) {
        myTripListView.subviews.forEach { $0.removeFromSuperview() }
        myTripListView.addSubviewAndLayout(view)
    }
    
    func initMyTripTabView(action: MyTripViewModelAction) {
        self.action = action
        segmentControl.setSelectedSegmentUnderline()
    }
    
    func setSegmentIndex(_ index: Int) {
        segmentControl.selectedSegmentIndex = index
        segmentControl.setSelectedSegmentUnderline()
    }
    
    func setStateViewData(_ stateData: StateViewData? = nil) {
        if let data = stateData {
            stateView.setData(data)
            stateView.isHidden = false
        } else {
            stateView.isHidden = true
        }
    }
    
    private lazy var stateView: StateView = StateView()
    private lazy var segmentControl: UISegmentedControl = createSegmentControl()
    private lazy var myTripListView: UIView = UIView()
    
    weak var action: MyTripViewModelAction?
}

private extension MyTripView {
    func setupView() {
        backgroundColor = Token.additionalColorsWhite
        stateView.isHidden = true
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            segmentControl,
            myTripListView,
            stateView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        addSubviewAndLayout(stackView, insets: UIEdgeInsets(edges: 21.0))
        initConstrain()
    }
    
    func createSegmentControl() -> UISegmentedControl  {
        let segmentController = UISegmentedControl(items: ["Upcoming", "History"])
        segmentController.selectedSegmentIndex = 0
        
        segmentController.setup()
        
        segmentController.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        return segmentController
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        sender.setSelectedSegmentUnderline()
        
        action?.segmentDidChange(to: sender.selectedSegmentIndex)
    }
    
    func initConstrain() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
