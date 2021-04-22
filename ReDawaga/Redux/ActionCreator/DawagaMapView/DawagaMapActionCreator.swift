//
//  DawagaMapActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import CoreLocation

struct DawagaMapActionCreator {}

extension DawagaMapActionCreator {
    
    // MARK: - With API Manager
    
    static func fetchSearchLocation(id: String) {
        
        appStore.dispatch(DawagaMapState.dawagaMapAction.setIsSearchLoadingLocation)
        
        APIManagerForGoogleMaps.shared.getPlaceDetails(placeId: id)
            .done { detailJSON in
                let location = Location.getLocationBy(json: detailJSON)
                appStore.dispatch(DawagaMapState.dawagaMapAction.setSearchLocation(location: location))
            }
            .catch { error in
                appStore.dispatch(DawagaMapState.dawagaMapAction.setIsErrorSearchLocation)
            }
    }
    
    static func fetchReverseGeocode(location: CLLocation) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setIsReverseLoadingLocation)
        
        APIManagerForGoogleMaps.shared.getReverseGeocode(location: location)
            .done { detailJSON in
                let location = Location.getLocationBy(json: detailJSON)
                appStore.dispatch(DawagaMapState.dawagaMapAction.setReverseLocation(location: location))
            }
            .catch { error in
                appStore.dispatch(DawagaMapState.dawagaMapAction.setIsErrorReverseLocation)
            }
    }
    
    // MARK: - Map Action
    
    static func fetchIdleLocation(location: CLLocation) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setIdleLocation(location: location))
    }
    

    // MARK: - Bottom View
    
    static func fetchDistanceState(with state: Int) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setDistanceState(state: state))
    }
    
    static func fetchBookMarkIconName(with name: String) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setBookMarkIconName(name: name))
    }
    
    
    // MARK: - Transition
    
    static func fetchDestination(with location: CLLocation?) {
        appStore.dispatch(DawagaMapState.dawagaMapAction.setDestination(location: location))
    }
}
