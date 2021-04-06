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
    
    state.bookMarkListState = BookMarkListReducer.reduce(action: action, state: state.bookMarkListState)
    
    state.placeSearchState = PlaceSearchReducer.reduce(action: action, state: state.placeSearchState)
    
    return state
}
