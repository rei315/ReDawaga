//
//  PlaceEntity.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/29.
//

import Foundation
import SwiftyJSON

struct PlaceEntity {
    let placeId: String
    let placeName: String
    
    init(json: JSON) {
        self.placeId = json["place_id"].string ?? ""
        self.placeName = json["description"].string ?? ""
    }
}

