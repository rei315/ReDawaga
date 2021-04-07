//
//  PlaceSearchAction.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import Foundation
import ReSwift

extension PlaceSearchState {
    
    enum placeSearchAction: ReSwift.Action {
        
        case setIsLoadingPlace
        
        case setPlaceList(place: [PlaceEntity])
        
        case setIsErrorPlace
        
        case setSelectedPlace(place: PlaceEntity)        
    }
}
