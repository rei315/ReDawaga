//
//  PlaceSearchActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import Foundation

struct PlaceSearchActionCreator {}

extension PlaceSearchActionCreator {
    
    static func fetchPlaceList(address: String) {
        
        appStore.dispatch(PlaceSearchState.placeSearchAction.setIsLoadingPlace)
        
        
        APIManagerForGoogleMaps.shared.getAutoCompleteList(address: address)
            .done { placesJSON in
                let placeList = Place.getPlaceListBy(json: placesJSON)                
                appStore.dispatch(PlaceSearchState.placeSearchAction.setPlace(place: placeList))
                
            }
            .catch { error in
                appStore.dispatch(PlaceSearchState.placeSearchAction.setIsErrorPlace)
            }
    }
}
