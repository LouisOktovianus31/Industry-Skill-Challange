//
//  ActivityDetailViewModelContract.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation

protocol ActivityDetailNavigationDelegate: AnyObject {
    func notifyActivityDetailPackageDidSelect(package: ActivityDetailDataModel, selectedPackageId: Int)
}

protocol ActivityDetailViewModelAction: AnyObject {
    func configureView(data: ActivityDetailDataModel)
    func updatePackageData(data: [ActivityDetailDataModel.Package])
}

protocol ActivityDetailViewModelProtocol: AnyObject {
    var actionDelegate: ActivityDetailViewModelAction? { get set }
    var navigationDelegate: ActivityDetailNavigationDelegate? { get set }
    
    func onViewDidLoad()
    func onPackageDetailStateDidChange(shouldShowAll: Bool)
    func onPackagesDetailDidTap(with packageId: Int)
}
