//
//  DawagaMapActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import CoreLocation
import ReSwift

struct DawagaMapActionCreator {}

extension DawagaMapActionCreator {
    
    // MARK: - With API Manager
    // Search
    static func fetchSearchLocation(location: LocationEntity?) -> ReSwift.Action {
        
        return DawagaMapState.dawagaMapAction.setSearchLocation(location: location)
    }
    static func fetchIsLoadingSearchLocation() -> ReSwift.Action {
        
        return DawagaMapState.dawagaMapAction.setIsLoadingSearchLocation
    }
    static func fetchIsErrorSearchLocation() -> ReSwift.Action {
        
        return DawagaMapState.dawagaMapAction.setIsErrorSearchLocation
    }
    
    // Reverse Geocode
    static func fetchReverseGeocode(location: String) -> ReSwift.Action {
        
        return DawagaMapState.dawagaMapAction.setReverseLocation(location: location)
    }
    static func fetchIsLoadingReverseLocation() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsLoadingReverseLocation
    }
    static func fetchIsErrorReverseLocation() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsErrorReverseLocation
    }
    
    
    // MARK: - Location Manager
    static func fetchIdleLocation(location: CLLocation?) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setIdleLocation(location: location))
    }
    

    // MARK: - Bottom View
    static func fetchDistanceState(with state: Int) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setDistanceState(state: state))
    }
    static func fetchBookMarkIconName(with name: String?) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setBookMarkIconName(name: name))
    }
    
    
    // MARK: - BookMark Realm
    // Save
    static func fetchIsLoadingSaveBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsLoadingSaveBookMark
    }
    static func fetchIsCompleteSaveBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsCompleteSaveBookMark
    }
    static func fetchIsErrorSaveBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsErrorSaveBookMark
    }
    
    
    // Edit
    static func fetchIsLoadingEditBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsLoadingEditBookMark
    }
    static func fetchIsCompleteEditBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsCompleteEditBookMark
    }
    static func fetchIsErrorEditBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsErrorEditBookMark
    }
    
    // Delete
    static func fetchIsLoadingDeleteBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsLoadingDeleteBookMark
    }
    static func fetchIsCompleteDeleteBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsCompleteDeleteBookMark
    }
    static func fetchIsErrorDeleteBookMark() -> ReSwift.Action {
        return DawagaMapState.dawagaMapAction.setIsErrorDeleteBookMark
    }
    
    // Init
    static func fetchInitRealmBookMark() {
        return appStore.dispatch(DawagaMapState.dawagaMapAction.setInitRealmBookMark)
    }
    
    
    // MARK: - Transition
    
    static func fetchDestination(with location: CLLocation?) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setDestination(location: location))
    }
}
