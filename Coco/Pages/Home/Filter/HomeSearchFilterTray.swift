//
//  HomeSearchFilterTray.swift
//  Coco
//
//  Created by Jackie Leonardy on 07/07/25.
//

import Foundation
import SwiftUI

struct HomeSearchFilterTray: View {
    @ObservedObject var viewModel: HomeSearchFilterTrayViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Search")
                .multilineTextAlignment(.center)
                .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                .foregroundStyle(Token.additionalColorsBlack.toColor())
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24.0) {
                    if !viewModel.dataModel.filterPillDataState.isEmpty {
                        VStack(alignment: .leading, spacing: 12.0) {
                            Text("Popular Filters")
                                .foregroundStyle(Token.additionalColorsBlack.toColor())
                                .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                             
                            ScrollView(.horizontal) {
                                HStack(spacing: 12.0) {
                                    ForEach(viewModel.dataModel.filterPillDataState, id: \.id) { state in
                                        HomeSearchFilterPillView(state: state, didTap: {
                                            viewModel.updateApplyButtonTitle()
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    HomeSearchFilterPriceRangeView(model: viewModel.dataModel.priceRangeModel, rangeDidChange: {
                        viewModel.updateApplyButtonTitle()
                    })
                    Spacer()
                    CocoButton(
                        action: {
                            viewModel.filterDidApply()
                        },
                        text: viewModel.applyButtonTitle,
                        style: .large,
                        type: .primary
                    )
                    .stretch()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24.0)
        .background(Color.white)
        .cornerRadius(16)
    }
}

private extension HomeSearchFilterTray {
    func createSectionView(
        title: String,
        view: (() -> some View)
    ) -> some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(title)
                .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                .foregroundStyle(Token.additionalColorsBlack.toColor())
            view()
        }
    }
}
