//
//  ImageCache.swift
//  CodeSample
//
//  Created by Ryan Lons on 10/7/22.
//  Copyright © 2022 Ryan Lons. All rights reserved.
//

import Foundation
import UIKit

private var _shared : ImageCache!

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(url: String) -> UIImage? {
        return cache.object(forKey: NSString(string: url))
    }
    
    func set(url: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: url))
    }
    
    class var shared: ImageCache {
        if _shared == nil {
            _shared = ImageCache()
        }
        return _shared
    }
}
