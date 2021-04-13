//
//  LocationEmitterAction.swift.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import ReSwift
import CoreLocation

extension LocationEmitterState {
    
    enum locationEmitterAction: ReSwift.Action {
        
        case setAuthorizationStatus(state: CLAuthorizationStatus)
        
        case setLocation(location: CLLocation?)
    }
}
