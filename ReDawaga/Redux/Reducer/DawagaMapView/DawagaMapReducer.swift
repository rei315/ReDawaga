//
//  DawagaMapReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import ReSwift

struct DawagaMapReducer {}

extension DawagaMapReducer {
    
    static func reduce(action: ReSwift.Action, state: DawagaMapState?) -> DawagaMapState {
        
        var state = state ?? DawagaMapState()
        
        guard let action = action as? DawagaMapState.dawagaMapAction else {
            return state
        }
        
        switch action {
        
        case .setIsSearchLoadingLocation:
            print("setIsSearchLoadingLocation")
            state.isSearchLoadingLocation = true
            
        case let .setSearchLocation(location):
            print("setSearchLocation")
            state.isSearchLoadingLocation = false
            state.searchLocationDetail = location
            state.isErrorSearchLocation = false
            
        case .setIsErrorSearchLocation:
            print("setIsErrorSearchLocation")
            state.isSearchLoadingLocation = false
            state.isErrorSearchLocation = true

        case let .setIdleLocation(location):
            print("setIdleLocation")
            state.idleLocation = location
            
        case .setIsReverseLoadingLocation:
            print("setIsReverseLoadingLocation")
            state.isReverseLoadingLocation = true
            
        case let .setReverseLocation(location):
            print("setReverseLocation")
            state.isReverseLoadingLocation = false
            state.reverseLocationDetail = location
            state.isErrorReverseLocation = false
            
        case let .setIsMapReady(isReady):
            print("setIsMapReady", isReady)
            state.isMapReady = isReady
            
        case .setIsErrorReverseLocation:
            print("setIsErrorReverseLocation")
            state.isReverseLoadingLocation = false
            state.isErrorReverseLocation = true
            
        case let .setDistanceState(distanceState):
            print("setDistanceState")
            state.distanceState = distanceState            
            
        case let .setBookMarkIconName(name):
            print("setBookMarkIconName")
            state.bookMarkIconName = name
            
        case let .setDestination(location):
            print("setDestination")
            state.destination = location
        }
        
        return state
    }
}
