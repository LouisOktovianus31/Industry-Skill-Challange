//
//  MyTripListCollectionViewModel.swift
//  Coco
//
//  Created by Arin Juan Sari on 17/08/25.
//

import Foundation

final class MyTripListCollectionViewModel {
    weak var delegate: MyTripListCollectionViewModelDelegate?
    private(set) var myTripListData: [MyTripListCardDataModel] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    var onDataUpdated: (() -> Void)?
}

extension MyTripListCollectionViewModel: MyTripListCollectionViewModelProtocol {
    func updateMyTripListData(_ data: [MyTripListCardDataModel]) {
        myTripListData = data
    }
    
    func onTripItemDidTap(_ dataModel: MyTripListCardDataModel, indexPath: IndexPath) {
        delegate?.notifyCollectionViewTripItemDidTap(dataModel, indexPath: indexPath)
    }
}
