//
//  MyTripCoordinator.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation
import UIKit

final class MyTripCoordinator: BaseCoordinator {
    struct Input {
        let navigationController: UINavigationController
        let flow: Flow
        
        enum Flow {
            case bookingDetail(data: BookingDetails)
        }
    }
    
    init(input: Input) {
        self.input = input
        super.init(navigationController: input.navigationController)
    }
    
    override func start() {
        super.start()
        
        switch input.flow {
        case .bookingDetail(let data):
            let bookingDetailViewModel: TripDetailViewModel = TripDetailViewModel(data: data)
            let bookingDetailViewController: TripDetailViewController = TripDetailViewController(viewModel: bookingDetailViewModel)
            
            start(viewController: bookingDetailViewController)
        }
    }
    
    private let input: Input
}
