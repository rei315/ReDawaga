//
//  AppReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import ReSwift

func appReduce(action: Action, state: AppState?) -> AppState {
    
    var state = state ?? AppState()
    
    state.locationEmitterState = LocationEmitterReducer.reduce(action: action, state: state.locationEmitterState)
    
    state.bookMarkListState = BookMarkListReducer.reduce(action: action, state: state.bookMarkListState)
    
    state.placeSearchState = PlaceSearchReducer.reduce(action: action, state: state.placeSearchState)
    
    state.dawagaMapState = DawagaMapReducer.reduce(action: action, state: state.dawagaMapState)
    
    state.bookMarkIconSelectorState = BookMarkIconSelectorReducer.reduce(action: action, state: state.bookMarkIconSelectorState)
    
    state.dawagaLoadingState = DawagaLoadingReducer.reduce(action: action, state: state.dawagaLoadingState)
    
    return state
}
