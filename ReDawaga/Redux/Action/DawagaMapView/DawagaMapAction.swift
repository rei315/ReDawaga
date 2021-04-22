//
//  DawagaMapAction.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import ReSwift
import CoreLocation

extension DawagaMapState {
    
    enum dawagaMapAction: ReSwift.Action {
        
        // MARK: - Search
        
        case setIsSearchLoadingLocation
        
        case setSearchLocation(location: LocationEntity?)
        
        case setIsErrorSearchLocation
        
        
        // MARK: - Reverse Geocode
        
        case setIsReverseLoadingLocation
        
        case setReverseLocation(location: LocationEntity?)
        
        case setIsErrorReverseLocation
        
        
        // MARK: - Map Action

        case setIdleLocation(location: CLLocation)
        

        // MARK: - Bottom View
        
        case setDistanceState(state: Int)
        
        case setBookMarkIconName(name: String)
        
        
        // MARK: - Transition
        
        case setDestination(location: CLLocation?)
    }
}
