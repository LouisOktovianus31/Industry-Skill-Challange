//
//  HomeView.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import UIKit

final class HomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addErrorView(from view: UIView) {
        errorView.subviews.forEach { $0.removeFromSuperview() }
        errorView.addSubviewAndLayout(view)
    }
    
    func addSearchResultView(from view: UIView) {
        searchResultView.subviews.forEach { $0.removeFromSuperview() }
        searchResultView.addSubviewAndLayout(view)
    }
    
    func addLoadingView(from view: UIView) {
        loadingView.subviews.forEach { $0.removeFromSuperview() }
        loadingView.addSubviewAndLayout(view)
    }
    
    func toggleErrorView(isShown: Bool) {
        errorView.isHidden = !isShown
    }
    
    func toggleLoadingView(isShown: Bool) {
        loadingView.isHidden = !isShown
    }
    
    func addSearchBarView(from view: UIView) {
        searchBarView.subviews.forEach { $0.removeFromSuperview() }
        searchBarView.addSubviewAndLayout(view, insets: .init(vertical: 0, horizontal: 24.0))
    }
    
    private lazy var errorView: UIView = UIView()
    private lazy var contentStackView: UIStackView = createContentStackView()
    private lazy var searchBarView: UIView = UIView()
    private lazy var searchResultView: UIView = UIView()
    private lazy var loadingView: UIView = UIView()
}

private extension HomeView {
    func setupView() {
        addSubviewAndLayout(contentStackView)
        addSubviewAndLayout(loadingView)
        addSubviewAndLayout(errorView)
        
        errorView.isHidden = true
        loadingView.isHidden = true
    }
    
    func createContentStackView() -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            searchBarView,
            searchResultView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }
}
