//
//  LocationEmitterReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import ReSwift
import CoreLocation

struct LocationEmitterReducer {}

extension LocationEmitterReducer {
    
    static func reduce(action: ReSwift.Action, state: LocationEmitterState?) -> LocationEmitterState {
        
        var state = state ?? LocationEmitterState()
        
        guard let action = action as? LocationEmitterState.locationEmitterAction else {
            return state
        }
        
        switch action {
        case let .setAuthorizationStatus(authorizationStatus):
            state.authorizationStatus = authorizationStatus
        case let .setLocation(location):
            state.location = location
        }
        
        return state
    }
}
