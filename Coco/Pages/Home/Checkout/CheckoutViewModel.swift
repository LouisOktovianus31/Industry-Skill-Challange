//
//  CheckoutViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation

final class CheckoutViewModel {
    weak var delegate: (any CheckoutViewModelDelegate)?
    weak var actionDelegate: (any CheckoutViewModelAction)?
    
    init(bookingResponse: BookingDetails) {
        self.bookingResponse = bookingResponse
    }
    
    private let bookingResponse: BookingDetails
}

extension CheckoutViewModel: CheckoutViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.configureView(bookingData: bookingResponse)
    }
    
    func bookNowDidTap() {
        actionDelegate?.showPopUpSuccess(completion: { [weak self] in
            self?.delegate?.notifyUserDidCheckout()
        })
    }
}
