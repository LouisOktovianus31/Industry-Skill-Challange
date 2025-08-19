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
    func onTripItemRebookDidTap(_ id: Int) {
        delegate?.notifyCollectionViewTripItemRebookDidTap(id)
    }
    
    func updateMyTripListData(_ data: [MyTripListCardDataModel]) {
        myTripListData = data
    }
    
    func onTripItemDidTap(_ id: Int) {
        delegate?.notifyCollectionViewTripItemDidTap(id)
    }
}
