//
//  HomeSearchSearchTray.swift
//  Coco
//
//  Created by Jackie Leonardy on 07/07/25.
//

import Foundation
import SwiftUI

struct HomeSearchSearchTray: View {
    @StateObject var viewModel: HomeSearchSearchTrayViewModel
    
    @State var latestSearches: [HomeSearchSearchLocationData]
    
    let searchDidApply: ((_ query: String) -> Void)
    
    init(
        selectedQuery: String,
        latestSearches: [HomeSearchSearchLocationData],
        searchDidApply: @escaping (_: String) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeSearchSearchTrayViewModel(
                searchBarViewModel: HomeSearchBarViewModel(
                    leadingIcon: CocoIcon.icSearchLoop.image,
                    placeholderText: "Search...",
                    currentTypedText: selectedQuery,
                    trailingIcon: nil,
                    isTypeAble: true,
                    delegate: nil
                )
            )
        )
        
        self.latestSearches = latestSearches
        self.searchDidApply = searchDidApply
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Filter Service")
                .multilineTextAlignment(.center)
                .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                .foregroundStyle(Token.additionalColorsBlack.toColor())
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24.0) {
                    HomeSearchBarView(viewModel: viewModel.searchBarViewModel)
                    
                    if !latestSearches.isEmpty {
                        createSectionView(title: "Last Search") {
                            lastSearchSectionView()
                        }
                    }
                    
                    if !viewModel.popularLocations.isEmpty {
                        createSectionView(title: "Popular Location") {
                            popularLocationSectionView()
                        }
                    }
                    
                    Spacer()
                    CocoButton(
                        action: {
                            searchDidApply(viewModel.searchBarViewModel.currentTypedText)
                        },
                        text: "Search",
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
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension HomeSearchSearchTray {
    func createSectionView(
        title: String,
        @ViewBuilder view: (() -> some View)
    ) -> some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(title)
                .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                .foregroundStyle(Token.additionalColorsBlack.toColor())
            view()
        }
    }
    
    func createLocationView(name: String) -> some View {
        HStack(alignment: .center, spacing: 14.0) {
            Image(uiImage: CocoIcon.icPinPointBlue.image)
                .resizable()
                .frame(width: 24.0, height: 24.0)
            
            Text(name)
                .font(.jakartaSans(forTextStyle: .callout, weight: .medium))
                .foregroundStyle(Token.additionalColorsBlack.toColor())
        }
        .onTapGesture {
            viewModel.searchBarViewModel.currentTypedText = name
        }
    }
    
    func createLastSearchView(name: String) -> some View {
        HStack(alignment: .center, spacing: 6.0) {
            Text(name)
                .lineLimit(1)
                .font(.jakartaSans(forTextStyle: .body, weight: .light))
                .foregroundStyle(Token.grayscale60.toColor())
            
            Image(uiImage: CocoIcon.icCross.image)
                .resizable()
                .frame(width: 15.0, height: 15.0)
        }
        .padding(.vertical, 12.0)
        .padding(.horizontal, 20.0)
        .background(Token.additionalColorsWhite.toColor())
        .overlay(
            RoundedRectangle(cornerRadius: 14.0)
                .stroke(Token.grayscale30.toColor(), lineWidth: 1.0)
        )
        .cornerRadius(14.0)
    }
    
    func lastSearchSectionView() -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 16.0) {
                ForEach(Array(latestSearches.enumerated()), id: \.0) { (index, location) in
                    createLastSearchView(name: location.name)
                        .onTapGesture {
                            withAnimation {
                                _ = latestSearches.remove(at: index)
                            }
                        }
                }
            }
        }
    }
    
    func popularLocationSectionView() -> some View {
        VStack(alignment: .leading, spacing: 15.0) {
            ForEach(Array(viewModel.popularLocations.enumerated()), id: \.0) { (index, location) in
                createLocationView(name: location.name)
                
                if index < viewModel.popularLocations.count {
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1.0)
                        .foregroundStyle(Token.additionalColorsLine.toColor())
                }
            }
        }
    }
}
