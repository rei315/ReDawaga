//
//  Location.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import SwiftyJSON

class Location {
    
    static func getLocationBy(json: JSON) -> LocationEntity {
        
        return LocationEntity.init(json: json)
    }
}
