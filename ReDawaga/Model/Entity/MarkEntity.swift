//
//  MarkEntity.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/29.
//

import Foundation
import UIKit
import CoreLocation

struct MarkEntity: Equatable {
    let name: String
    let location: CLLocation
    let address: String
    let iconName: String
    
    init(name: String, latitiude: Double, longitude: Double, address: String, iconName: String) {
        self.name = name
        self.location = CLLocation(latitude: latitiude, longitude: longitude)
        self.address = address
        self.iconName = iconName
    }
}
