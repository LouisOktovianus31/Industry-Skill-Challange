//
//  Font+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 06/07/25.
//

import Foundation
import SwiftUI

extension Font {
    static func jakartaSans(
        forTextStyle style: UIFont.TextStyle,
        weight: UIFont.Weight = .regular
    ) -> Self {
        UIFont.jakartaSans(
            forTextStyle: style,
            weight: weight
        ).toFont()
    }
}
