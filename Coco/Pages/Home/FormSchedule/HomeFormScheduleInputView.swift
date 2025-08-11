//
//  HomeFormScheduleInputView.swift
//  Coco
//
//  Created by Jackie Leonardy on 23/07/25.
//

import SwiftUI

struct HomeFormScheduleInputView: View {
    @ObservedObject var calendarViewModel: HomeSearchBarViewModel
    @ObservedObject var paxInputViewModel: HomeSearchBarViewModel
    
    var actionButtonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                Text("Date Visit")
                    .font(.jakartaSans(forTextStyle: .footnote, weight: .medium))
                    .foregroundStyle(Token.grayscale70.toColor())
                
                HomeSearchBarView(viewModel: calendarViewModel)
            }
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text("Number of People")
                    .font(.jakartaSans(forTextStyle: .footnote, weight: .medium))
                    .foregroundStyle(Token.grayscale70.toColor())
                HomeSearchBarView(viewModel: paxInputViewModel)
            }
            
            Spacer()
            
            CocoButton(
                action: actionButtonAction,
                text: "Checkout",
                style: .large,
                type: .primary
            )
            .stretch()
        }
    }
}
