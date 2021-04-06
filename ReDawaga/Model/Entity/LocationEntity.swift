//
//  LocationEntity.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/29.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct LocationEntity {
    let title: String
    let location: CLLocation
    
    init(json: JSON) {
        self.title = json["formatted_address"].string ?? ""
        if let geometry = json["geometry"].dictionary {
            if let location = geometry["location"]?.dictionary {
                let lat = location["lat"]?.double ?? 0
                let lon = location["lon"]?.double ?? 0
                
                self.location = CLLocation(latitude: lat, longitude: lon)
            } else {
                self.location = CLLocation(latitude: 0, longitude: 0)
            }
        } else {
            self.location = CLLocation(latitude: 0, longitude: 0)
        }

    }
}
