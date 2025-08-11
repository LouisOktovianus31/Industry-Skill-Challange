//
//  HomeSearchFilterPriceRangeView.swift
//  Coco
//
//  Created by Jackie Leonardy on 09/07/25.
//

import Foundation
import SwiftUI

private let kKnobSize: CGFloat = 40.0

struct HomeSearchFilterPriceRangeView: View {
    @ObservedObject var model: HomeSearchFilterPriceRangeModel
    let rangeDidChange: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text("Price Range")
                    .foregroundStyle(Token.additionalColorsBlack.toColor())
                Spacer()
                Text("Rp\(Int(model.minPrice)) - Rp\(Int(model.maxPrice))")
                    .font(.jakartaSans(forTextStyle: .body, weight: .semibold))
                    .foregroundStyle(Token.mainColorPrimary.toColor())
            }
            .font(.jakartaSans(forTextStyle: .body, weight: .semibold))

            GeometryReader { geo in
                let width = geo.size.width
                let lowerRatio = CGFloat((model.minPrice - model.range.lowerBound) / (model.range.upperBound - model.range.lowerBound))
                let upperRatio = CGFloat((model.maxPrice - model.range.lowerBound) / (model.range.upperBound - model.range.lowerBound))

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Token.additionalColorsLine.toColor())
                        .frame(height: 6)

                    Capsule()
                        .fill(Token.mainColorPrimary.toColor())
                        .frame(
                            width: (upperRatio - lowerRatio) * width,
                            height: 6
                        )
                        .offset(x: lowerRatio * width)

                    // Min thumb
                    knobView()
                        .offset(x: lowerRatio * width - (kKnobSize / 2))
                        .gesture(DragGesture().onChanged { value in
                            let percent = min(max(0, value.location.x / width), upperRatio)
                            let newValue = model.range.lowerBound + Double(percent) * (model.range.upperBound - model.range.lowerBound)
                            model.minPrice = min(max(model.range.lowerBound, round(newValue / model.step) * model.step), model.maxPrice - model.step)
                            
                            rangeDidChange()
                        })

                    // Max thumb
                    knobView()
                        .offset(x: upperRatio * width - (kKnobSize / 2))
                        .gesture(DragGesture().onChanged { value in
                            let percent = max(min(1, value.location.x / width), lowerRatio)
                            let newValue = model.range.lowerBound + Double(percent) * (model.range.upperBound - model.range.lowerBound)
                            model.maxPrice = max(min(model.range.upperBound, round(newValue / model.step) * model.step), model.minPrice + model.step)
                            
                            rangeDidChange()
                        })
                }
                .frame(height: 44)
            }
            .frame(height: 44)
            .padding(.horizontal, 20.0)
        }
    }
}

private extension HomeSearchFilterPriceRangeView {
    func knobView() -> some View {
        HStack(spacing: 0) {
            Image(uiImage: CocoIcon.icChevronLeft.image)
            Image(uiImage: CocoIcon.icChevronRight.image)
        }
        .frame(width: kKnobSize, height: kKnobSize)
        .background(Token.mainColorPrimary.toColor())
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 4)
        )
    }
}
