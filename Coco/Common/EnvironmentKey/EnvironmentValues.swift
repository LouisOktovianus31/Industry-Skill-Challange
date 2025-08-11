//
//  EnvironmentValues.swift
//  Coco
//
//  Created by Jackie Leonardy on 07/07/25.
//

import Foundation
import SwiftUI

extension CocoButton {
    func stretch() -> some View {
        self.environment(\.isStretch, true)
    }
}

extension EnvironmentValues {
    var isStretch: Bool {
        get { self[StretchKey.self] }
        set { self[StretchKey.self] = newValue }
    }
}

private struct StretchKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
