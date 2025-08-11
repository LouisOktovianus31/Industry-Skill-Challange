//
//  CocoImageSlider.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

struct ImageSliderView: View {
    let images: [String]
    @State private var currentIndex: Int = 0
    
    @Namespace private var dotAnimation

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    GeometryReader { geo in
                        AsyncImage(url: URL(string: images[index])) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: 341)
                                .clipped()
                        } placeholder: {
                            Color.gray.frame(height: 341)
                        }
                    }
                    .frame(height: 341)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: 8) {
                ForEach(images.indices, id: \.self) { index in
                    Capsule()
                        .fill(
                            currentIndex == index
                                ? Token.mainColorLemon.toColor()
                                : UIColor.from("#EAEAEA").toColor()
                        )
                        .frame(width: currentIndex == index ? 24.0 : 8.0, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                currentIndex = index
                            }
                        }
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
        .frame(height: 341)
    }
}

final class ImageSliderHostingController: UIHostingController<ImageSliderView> {
    init(images: [String]) {
        let view = ImageSliderView(images: images)
        super.init(rootView: view)
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
