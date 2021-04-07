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
            state.isSearchLoadingLocation = true
            
        case let .setSearchLocation(location):
            state.isSearchLoadingLocation = false
            state.searchLocationDetail = location
            state.isErrorSearchLocation = false
            
        case .setIsErrorSearchLocation:
            state.isSearchLoadingLocation = false
            state.isErrorSearchLocation = true
        
        case let .setIsRequestMonotoring(isMonitoring):
            state.isRequestMonitoring = isMonitoring
                            
        case let .setAuthorization(isAuthorized):
            state.isAuthorization = isAuthorized
        
        case let .setIdleLocation(location):
            state.idleLocation = location
            
        case .setIsReverseLoadingLocation:
            state.isReverseLoadingLocation = true
            
        case let .setReverseLocation(location):
            state.isReverseLoadingLocation = false
            state.reverseLocationDetail = location
            state.isErrorReverseLocation = false
            
        case .setIsErrorReverseLocation:
            state.isReverseLoadingLocation = false
            state.isErrorReverseLocation = true
        }
        
        return state
    }
}
