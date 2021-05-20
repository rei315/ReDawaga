//
//  DawagaMapAction.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import ReSwift
import CoreLocation

extension DawagaMapState {
    
    enum dawagaMapAction: ReSwift.Action {
        
        // MARK: - Search
        case setIsLoadingSearchLocation
        case setSearchLocation(location: LocationEntity?)
        case setIsErrorSearchLocation
        
        
        // MARK: - Reverse Geocode
        case setIsLoadingReverseLocation
        case setReverseLocation(location: String?)
        case setIsErrorReverseLocation
        
        
        // MARK: - Location Manager
        case setIdleLocation(location: CLLocation?)
        

        // MARK: - Bottom View
        case setDistanceState(state: Int)
        case setBookMarkIconName(name: String?)
        
        
        // MARK: - BookMark Realm
        case setIsLoadingSaveBookMark
        case setIsCompleteSaveBookMark
        case setIsErrorSaveBookMark
                
        case setIsLoadingEditBookMark
        case setIsCompleteEditBookMark
        case setIsErrorEditBookMark
        
        case setIsLoadingDeleteBookMark
        case setIsCompleteDeleteBookMark
        case setIsErrorDeleteBookMark
        
        case setInitRealmBookMark
        
        
        // MARK: - Transition
        case setDestination(location: CLLocation?)
    }
}
