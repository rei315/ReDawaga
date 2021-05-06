//
//  PlaceSearchActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import Foundation
import ReSwift

struct PlaceSearchActionCreator {}

extension PlaceSearchActionCreator {
    
    static func fetchPlaceList(placeList: [PlaceEntity]) -> ReSwift.Action {
        return PlaceSearchState.placeSearchAction.setPlaceList(place: placeList)
    }

    
    static func fetchSelectedPlace(place: PlaceEntity) {
        appStore.dispatch(PlaceSearchState.placeSearchAction.setSelectedPlace(place: place))
    }
    
    static func fetchIsLoadingPlace() -> ReSwift.Action {
        
        return PlaceSearchState.placeSearchAction.setIsLoadingPlace
    }
    
    static func fetchIsErrorPlace() -> ReSwift.Action {
        
        return PlaceSearchState.placeSearchAction.setIsErrorPlace
    }
}
