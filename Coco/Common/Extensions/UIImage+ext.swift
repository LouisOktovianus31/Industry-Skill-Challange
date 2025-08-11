//
//  UIImage+ext.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL?, cacheKey: String? = nil) {
        guard let url: URL else { return }
        
        let key: String = cacheKey ?? url.absoluteString
        
        if let cachedImage: UIImage = ImageCacheManager.shared.image(forKey: key) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return
            }
            
            ImageCacheManager.shared.set(image, forKey: key)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
