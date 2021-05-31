//
//  DawagaMapState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import ReSwift
import CoreLocation

struct DawagaMapState: ReSwift.StateType {
    
    enum BookMarkState {
        case isLoading, isComplete, isError
    }
    
    enum RealmBookMarkType: Equatable{
        case none
        case save(state: BookMarkState)
        case edit(state: BookMarkState)
        case delete(state: BookMarkState)
    }
    
    // MARK: - Search
    var isLoadingSearchLocation: Bool = false
    var searchLocationDetail: LocationEntity?
    var isErrorSearchLocation: Bool = false
                
    
    // MARK: - Reverse Geocode
    var isLoadingReverseLocation: Bool = false
    var reverseLocationDetail: String = ""
    var isErrorReverseLocation: Bool = false
    
    
    // MARK: - Location Manager
    var idleLocation: CLLocation?
    
    
    // MARK: - Bottom View
    var distanceState: Int = DawagaMapBottomView.DistanceState.Fifty.rawValue
    var bookMarkIconName: String? = nil
    
    
    // MARK: - BookMark Realm
    var realmBookMarkType: RealmBookMarkType = .none
    
    
    // MARK: - Transition
    var destination: CLLocation? = nil            
}
