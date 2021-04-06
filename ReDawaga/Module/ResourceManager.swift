//
//  ResourceManager.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/01.
//

import UIKit
import PromiseKit

struct ResourceManager {
    
    // MARK: - Singleton Instance
    
    static let shared = ResourceManager()
            
    private init() {}
    
    
    //
    //ResourceManager.shared.fetchMarkIcons()
    //    .done { imgName in
    //
    //    }
    //    .catch { error in
    //
    //    }
    //
    // MARK: - Function

    func fetchMarkIcons() -> Promise<[String]> {
        
        var strList: [String] = []
        
        return Promise { seal in
            if let f = Bundle.main.url(forResource: "MarkIcon", withExtension: nil) {
                let fm = FileManager()
                do {
                    let datas = try fm.contentsOfDirectory(at: f, includingPropertiesForKeys: nil, options: [])
                    strList = datas.map { $0.absoluteString }
                    seal.fulfill(strList)
                } catch {
                    seal.reject(error)
                    assertionFailure("fetchMarkIcons Error")
                }
            }
        }
    }
    
    func getImageFromURL(str: String) -> UIImage {
        if let imageUrl = URL(string: str) {
            do {
                let imageData = try Data(contentsOf: imageUrl)
                return UIImage(data: imageData) ?? UIImage()
            }
            catch {
                assertionFailure("getImageFromURL Error")
            }
        }
        return UIImage()
    }
    
    func loadImageWithFileName(fileName: String) -> UIImage {
        if let f = Bundle.main.url(forResource: "MarkIcon", withExtension: nil) {
            do {
                let url = f.appendingPathComponent(fileName)
                let imageData = try Data(contentsOf: url)
                return UIImage(data: imageData) ?? UIImage()
            } catch {
                assertionFailure("loadImageWithFileName Error")
            }
        }
        return UIImage()
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


