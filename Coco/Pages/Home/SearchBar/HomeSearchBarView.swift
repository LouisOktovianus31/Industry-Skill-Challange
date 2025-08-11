//
//  HomeSearchBarView.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

struct HomeSearchBarView: View {
    @ObservedObject var viewModel: HomeSearchBarViewModel
    
    var body: some View {
        CocoInputTextField(
            leadingIcon: viewModel.leadingIcon,
            currentTypedText: $viewModel.currentTypedText,
            trailingIcon: viewModel.trailingIcon,
            placeholder: viewModel.placeholderText,
            shouldInterceptFocus: !viewModel.isTypeAble,
            onFocusedAction: viewModel.onTextFieldFocusDidChange(to:)
        )
    }
}

final class HomeSearchBarHostingController: UIHostingController<HomeSearchBarView> {
    init(viewModel: HomeSearchBarViewModel) {
        let view = HomeSearchBarView(viewModel: viewModel)
        super.init(rootView: view)
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
