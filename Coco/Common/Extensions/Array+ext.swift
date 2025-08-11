//
//  Array+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 02/07/25.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
