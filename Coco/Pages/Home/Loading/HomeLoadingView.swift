//
//  HomeLoadingView.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

struct HomeLoadingView: View {
    @ObservedObject var state: HomeLoadingState
    @State var currentTypedText: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 32.0) {
            Text("Loading...")
                .font(
                    .jakartaSans(
                        forTextStyle: .title2,
                        weight: .bold
                    )
                )
            
            CocoLoadingBar(percentage: state._percentage)
        }
        .padding(16.0)
    }
}
