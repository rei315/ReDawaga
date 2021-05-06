//
//  ImageCacheManager.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/03.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
