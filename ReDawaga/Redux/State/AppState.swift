//
//  AppState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import ReSwift

struct AppState: ReSwift.StateType {
    
    var bookMarkListState = BookMarkListState()
    
    var placeSearchState = PlaceSearchState()
    
    var dawagaMapState = DawagaMapState()
}
