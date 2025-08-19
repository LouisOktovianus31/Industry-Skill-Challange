//
//  MyTripListCollectionViewController.swift
//  Coco
//
//  Created by Arin Juan Sari on 17/08/25.
//

import UIKit

class MyTripListCollectionViewController: UIViewController {
    private let viewModel: MyTripListCollectionViewModelProtocol
    private lazy var collectionView: UICollectionView = createCollectionView()
    
    init(viewModel: MyTripListCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.layoutSubviews()
            }
        }
    }
}

extension MyTripListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.myTripListData.count
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyTripListCardView", for: indexPath) as? MyTripListCardView else {
            return UICollectionViewCell()
        }
        cell.configureView(dataModel: viewModel.myTripListData[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension MyTripListCollectionViewController: MyTripListCardViewDelegate {
    func notifyRebookDidTap(at id: Int) {
        viewModel.onTripItemRebookDidTap(id)
    }
    
    func notifyTripListCardDidTap(at id: Int) {
        viewModel.onTripItemDidTap(id)
    }
}

extension MyTripListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectecTripData = viewModel.myTripListData[indexPath.row]
        viewModel.onTripItemDidTap(selectecTripData.id)
    }
}

private extension MyTripListCollectionViewController {
    func createCollectionView() -> UICollectionView {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 8.0, right: 0)
        collectionView.register(MyTripListCardView.self, forCellWithReuseIdentifier: "MyTripListCardView")
        
        return collectionView
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {(sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8.0, trailing: 0)

            return section
        }
    }
}
