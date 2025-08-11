//
//  CheckoutViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation

protocol CheckoutViewModelDelegate: AnyObject {
    func notifyUserDidCheckout()
}

protocol CheckoutViewModelAction: AnyObject {
    func configureView(bookingData: BookingDetails)
    func showPopUpSuccess(completion: @escaping () -> Void)
}

protocol CheckoutViewModelProtocol: AnyObject {
    var delegate: CheckoutViewModelDelegate? { get set }
    var actionDelegate: CheckoutViewModelAction? { get set }
    
    init(bookingResponse: BookingDetails)
    
    func onViewDidLoad()
    func bookNowDidTap()
}
