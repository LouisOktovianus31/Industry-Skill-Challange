//
//  InviteTravelerCollectionViewController.swift
//  Coco
//
//  Created by Arin Juan Sari on 20/08/25.
//

import UIKit

class InviteTravelerCollectionViewController: UIViewController {
    private let viewModel: InviteTravellerCollectionViewModelProtocol
    private lazy var collectionView: UICollectionView = createCollectionView()
    
    init(viewModel: InviteTravellerCollectionViewModelProtocol) {
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

extension InviteTravelerCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.emailTravelerListData.count
        print("count \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InviteTravelerCellView", for: indexPath) as? InviteTravelerCellView else {
            return UICollectionViewCell()
        }
        cell.configureView(dataModel: viewModel.emailTravelerListData[indexPath.row], index: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

extension InviteTravelerCollectionViewController: InviteTravelerCellViewDelegate {
    func didTapOnRemoveButton(at index: Int) {
        viewModel.onRemoveEmailTraveler(at: index)
    }
}

private extension InviteTravelerCollectionViewController {
    func createCollectionView() -> UICollectionView {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 8.0, right: 0)
        collectionView.register(InviteTravelerCellView.self, forCellWithReuseIdentifier: "InviteTravelerCellView")
        
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
