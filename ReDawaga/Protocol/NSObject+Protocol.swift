//
//  NSObject+Protocol.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import UIKit

extension NSObjectProtocol {

    //クラス名を返す変数"className"を返す
    static var className: String {
        return String(describing: self)
    }
}
