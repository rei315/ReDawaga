//
//  PlaceSearchState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import Foundation
import ReSwift

struct PlaceSearchState: ReSwift.StateType {
    
    var isLoadingPlace: Bool = false
    
    var placeList: [PlaceEntity] = []
    
    var isErrorPlace: Bool = false
            
    var selectedPlace: PlaceEntity? = nil
}
