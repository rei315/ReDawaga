//
//  LocationEmitterActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import CoreLocation

struct LocationEmitterActionCreator {}

extension LocationEmitterActionCreator {

    static func fetchAuthorizationStatus(state: CLAuthorizationStatus) {
        appStore.dispatch(LocationEmitterState.locationEmitterAction.setAuthorizationStatus(state: state))
    }
    
    static func fetchLocation(location: CLLocation?) {
        appStore.dispatch(LocationEmitterState.locationEmitterAction.setLocation(location: location))
    }
}
