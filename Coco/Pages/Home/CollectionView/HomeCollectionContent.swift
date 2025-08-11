//
//  HomeCollectionContent.swift
//  Coco
//
//  Created by Jackie Leonardy on 04/07/25.
//

import Foundation
import UIKit

typealias HomeCollectionViewDataSource = UICollectionViewDiffableDataSource<HomeCollectionContent.Section, AnyHashable>
typealias HomeCollectionViewSnapShot = NSDiffableDataSourceSnapshot<HomeCollectionContent.Section, AnyHashable>

struct HomeCollectionContent {
    let section: Section
    let items: [AnyHashable]
    
    enum SectionType: Hashable {
        case activity
    }
    
    struct Section: Hashable {
        let type: SectionType
        let title: String?
    }
}
