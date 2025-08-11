//
//  CocoLoadingBar.swift
//  Coco
//
//  Created by Jackie Leonardy on 05/07/25.
//

import Foundation
import SwiftUI

private let loaderHeight: CGFloat = 8.0

struct CocoLoadingBar: View {
    /// Percntage range from 0 ~ 100
    var percentage: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4.0, style: .circular)
                    .fill(UIColor.from("#DEE3E3").toColor())
                    .frame(height: loaderHeight)
                    
                RoundedRectangle(cornerRadius: 4.0, style: .circular)
                    .fill(Token.mainColorPrimary.toColor())
                    .frame(width: proxy.size.width * (percentage / 100), height: loaderHeight)
                    .animation(.easeInOut(duration: 0.3), value: percentage)
            }
        }
        .frame(height: loaderHeight)
    }
}
