//
//  Location.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import SwiftyJSON

class Location {
    
    static func getLocationListBy(json: JSON) -> [LocationEntity] {
        
        var locationEntityList: [LocationEntity] = []
        
        for (key: _, value: newJSON) in json {
            locationEntityList.append(LocationEntity.init(json: newJSON))
        }
        return locationEntityList
    }
}
