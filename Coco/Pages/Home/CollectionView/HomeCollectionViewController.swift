//
//  HomeCollectionViewController.swift
//  Coco
//
//  Created by Jackie Leonardy on 04/07/25.
//

import Foundation
import UIKit

final class HomeCollectionViewController: UIViewController {
    init(viewModel: HomeCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.actionDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        viewModel.onViewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionView
    }
    
    var dataSource: HomeCollectionViewDataSource?
    
    private let viewModel: HomeCollectionViewModelProtocol
    private lazy var collectionView: UICollectionView = createCollectionView()
}

extension HomeCollectionViewController: HomeCollectionViewModelAction {
    func configureDataSource() {
        let activityCellRegistration: ActivityCellRegistration = createActivityCellRegistration()
        let headerRegistration: HeaderRegistration = createHeaderRegistration()
        
        dataSource = HomeCollectionViewDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item: AnyHashable) -> UICollectionViewCell? in
            switch item {
            case let item as HomeActivityCellDataModel:
                return collectionView.dequeueConfiguredReusableCell(using: activityCellRegistration, for: indexPath, item: item)
            default:
                return nil
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
            
            return nil
        }
    }
    
    func applySnapshot(_ snapshot: HomeCollectionViewSnapShot, completion: (() -> Void)?) {
        dataSource?.apply(snapshot, completion: completion)
    }
}

extension HomeCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item: AnyHashable = dataSource?.itemIdentifier(for: indexPath) else {
             return
        }
        
        switch item {
        case let item as HomeActivityCellDataModel:
            viewModel.onActivityDidTap(item)
        default:
            break
        }
    }
}

private extension HomeCollectionViewController {
    func createCollectionView() -> UICollectionView {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 8.0, right: 0)
        
        return collectionView
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.sectionIdentifier(for: sectionIndex) else { return nil }
            
            switch sectionIdentifier.type {
            case .activity:
                var sectionConfiguration: UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
                sectionConfiguration.headerMode = .supplementary
                sectionConfiguration.showsSeparators = false
                sectionConfiguration.backgroundColor = .clear
                let section: NSCollectionLayoutSection = NSCollectionLayoutSection.list(using: sectionConfiguration, layoutEnvironment: layoutEnvironment)

                let sectionHeader: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [sectionHeader]
                section.interGroupSpacing = CGFloat(20)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24.0, bottom: 8.0, trailing: 24.0)
                return section
            }
        }
    }
}

// MARK: Cell Registration
private extension HomeCollectionViewController {
    typealias ActivityCellRegistration = UICollectionView.CellRegistration<HomeActivityCell, HomeActivityCellDataModel>
    func createActivityCellRegistration() -> ActivityCellRegistration {
        .init { [weak self] cell, _, itemIdentifier in
            guard let self else { return }
            cell.configureCell(itemIdentifier)
        }
    }
    
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HomeReusableHeader>
    func createHeaderRegistration() -> HeaderRegistration {
        .init(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, indexPath in
            guard let section: HomeCollectionContent.Section = self?.dataSource?.sectionIdentifier(for: indexPath.section),
                  let sectionTitle: String = section.title
            else {
                return
            }
            supplementaryView.configureView(title: sectionTitle)
        }
    }
}
