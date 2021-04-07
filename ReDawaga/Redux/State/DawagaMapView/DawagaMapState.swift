//
//  DawagaMapState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import ReSwift
import CoreLocation

struct DawagaMapState: ReSwift.StateType {
    
    // MARK: - Search
    
    var isSearchLoadingLocation: Bool = false
    
    var searchLocationDetail: LocationEntity?
    
    var isErrorSearchLocation: Bool = false
                
    
    // MARK: - Reverse Geocode
        
    var isReverseLoadingLocation: Bool = false
    
    var reverseLocationDetail: LocationEntity?
    
    var isErrorReverseLocation: Bool = false
    
    
    // MARK: - Location Manager
    
    var isRequestMonitoring: Bool = false
    
    var isAuthorization: Bool = false
    
    var idleLocation: CLLocation?    
}
