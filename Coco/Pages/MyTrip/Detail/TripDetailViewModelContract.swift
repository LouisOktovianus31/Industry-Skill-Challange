//
//  TripDetailViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 17/07/25.
//

import Foundation

protocol TripDetailViewModelAction: AnyObject {
    func configureView(dataModel: BookingDetailDataModel)
}

protocol TripDetailViewModelProtocol: AnyObject {
    var actionDelegate: TripDetailViewModelAction? { get set }
    
    func onViewDidLoad()
}
