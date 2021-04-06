//
//  PlaceSearchReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import Foundation
import ReSwift

struct PlaceSearchReducer {}

extension PlaceSearchReducer {
    
    static func reduce(action: ReSwift.Action, state: PlaceSearchState?) -> PlaceSearchState {
        
        var state = state ?? PlaceSearchState()
        
        guard let action = action as? PlaceSearchState.placeSearchAction else {
            return state
        }
        
        switch action {
        
        case .setIsLoadingPlace:
            state.isLoadingPlace = true
        case let .setPlace(place):
            state.isLoadingPlace = false
            state.placeList = place
            state.isErrorPlace = false
        case .setIsErrorPlace:
            state.isLoadingPlace = false
            state.isErrorPlace = true
        }
        
        return state
    }
}
