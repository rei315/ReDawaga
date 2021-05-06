//
//  ResourceManager.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/01.
//

import UIKit
import PromiseKit
import Foundation

struct ResourceManager {
    
    // MARK: - Singleton Instance
    
    static let shared = ResourceManager()
            
    private init() {}
    
    
    // MARK: - Function

    func fetchMarkIcons() -> Promise<[String]> {
        
        var strList: [String] = []
        
        return Promise { seal in
            if let f = Bundle.main.url(forResource: "MarkIcon", withExtension: nil) {
                let fm = FileManager()
                do {
                    let datas = try fm.contentsOfDirectory(at: f, includingPropertiesForKeys: nil, options: [])
                    strList = datas.map { getFileName(fullURL: $0.absoluteString) }
                    seal.fulfill(strList)
                } catch {
                    seal.reject(error)
                    assertionFailure("fetchMarkIcons Error")
                }
            }
        }
    }
    
    func loadImageWithFileName(fileName: String) -> UIImage? {
        let cacheKey = NSString(string: fileName)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            return cachedImage
        } else {
            if let f = Bundle.main.url(forResource: "MarkIcon", withExtension: nil) {
                do {
                    let url = f.appendingPathComponent(fileName)
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData){
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        return image
                    }
                    else {
                        return nil
                    }
                } catch {
                    assertionFailure("loadImageWithFileName Error")
                }
            }
        }
        
        return nil
    }
    
    func getFileName(fullURL: String) -> String{
        let url = URL(string: fullURL)
        let filenames = url?.lastPathComponent.components(separatedBy: ".") ?? []
        if let first = filenames.first, let last = filenames.last {
            return first + "." + last
        }
        
        return ""
    }
}


