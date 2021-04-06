//
//  DeviceSize.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/01.
//

import Foundation
import UIKit

struct DeviceSize {

    // MARK: - Static Function    

    static func bounds() -> CGRect {
        return UIScreen.main.bounds
    }

    static func screenWidth() -> CGFloat {
        return self.bounds().width
    }

    static func screenHeight() -> CGFloat {
        return self.bounds().height
    }
}
