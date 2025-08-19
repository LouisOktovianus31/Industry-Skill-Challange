//
//  MyTripListCollectionViewModelContract.swift
//  Coco
//
//  Created by Arin Juan Sari on 17/08/25.
//

import Foundation

protocol MyTripListCollectionViewModelDelegate: AnyObject {
    func notifyCollectionViewTripItemDidTap(_ id: Int)
    func notifyCollectionViewTripItemRebookDidTap(_ id: Int)
}

protocol MyTripListCollectionViewModelProtocol: AnyObject {
    var delegate: MyTripListCollectionViewModelDelegate? { get set }
    
    var myTripListData: [MyTripListCardDataModel] { get }
    var onDataUpdated: (() -> Void)? { get set }
        
    func updateMyTripListData(_ data: [MyTripListCardDataModel])
    func onTripItemDidTap(_ id: Int)
    func onTripItemRebookDidTap(_ id: Int)
}
