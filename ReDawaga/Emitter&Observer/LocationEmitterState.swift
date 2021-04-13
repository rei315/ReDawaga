//
//  LocationEmitterState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import CoreLocation
import ReSwift

struct LocationEmitterState: ReSwift.StateType {
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var location: CLLocation? = nil
}
