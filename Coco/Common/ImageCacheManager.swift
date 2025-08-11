//
//  ImageCacheManager.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

final class ImageCacheManager {
    static let shared: ImageCacheManager = ImageCacheManager()

    private let cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

    private init() {}

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func clearAll() {
        cache.removeAllObjects()
    }
}
