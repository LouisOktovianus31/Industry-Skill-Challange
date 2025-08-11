//
//  CocoStatusLabel.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

struct CocoStatusLabel: View {
    var title: String
    var style: CocoStatusLabelStyle
    
    var body: some View {
        Text(title)
            .lineLimit(1)
            .font(.jakartaSans(forTextStyle: .footnote, weight: .light))
            .foregroundStyle(style.textColor.toColor())
            .padding(.vertical, 4.0)
            .padding(.horizontal, 16.0)
            .background(style.backgroundColor.toColor())
            .cornerRadius(4.0)
    }
}

final class CocoStatusLabelHostingController: UIHostingController<CocoStatusLabel>, ObservableObject {
    private var titleData: String {
        didSet {
            rootView = CocoStatusLabel(title: titleData, style: style)
        }
    }

    private var style: CocoStatusLabelStyle

    init(
        title: String,
        style: CocoStatusLabelStyle
    ) {
        self.titleData = title
        self.style = style
        
        super.init(rootView: CocoStatusLabel(title: titleData, style: style))
    }

    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(_ newTitle: String) {
        self.rootView.title = newTitle
    }
    
    func updateStyle(_ newStyle: CocoStatusLabelStyle) {
        self.rootView.style = newStyle
    }
}
