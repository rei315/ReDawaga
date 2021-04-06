//
//  Place.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import SwiftyJSON

class Place {
    
    static func getPlaceListBy(json: JSON) -> [PlaceEntity] {
        
        var placeEntityList: [PlaceEntity] = []
        
        for (key: _, value: newJSON) in json {
            placeEntityList.append(PlaceEntity.init(json: newJSON))
        }
        return placeEntityList
    }
}
