//
//  DawagaMapReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import Foundation
import ReSwift

struct DawagaMapReducer {}

extension DawagaMapReducer {
    
    static func reduce(action: ReSwift.Action, state: DawagaMapState?) -> DawagaMapState {
        
        var state = state ?? DawagaMapState()
        
        guard let action = action as? DawagaMapState.dawagaMapAction else {
            return state
        }
        
        switch action {
        
        // MARK: - Search
        case .setIsLoadingSearchLocation:
            state.isSearchLoadingLocation = true
        case let .setSearchLocation(location):
            state.isSearchLoadingLocation = false
            state.searchLocationDetail = location
            state.isErrorSearchLocation = false
        case .setIsErrorSearchLocation:
            state.isSearchLoadingLocation = false
            state.isErrorSearchLocation = true
            
            
        // MARK: - Location Manager
        case let .setIdleLocation(location):
            state.idleLocation = location
            
            
        // MARK: - Reverse Geocode
        case .setIsLoadingReverseLocation:
            state.isReverseLoadingLocation = true
        case let .setReverseLocation(locationTitle):
            state.isReverseLoadingLocation = false
            state.reverseLocationDetail = locationTitle ?? ""
            state.isErrorReverseLocation = false
        case .setIsErrorReverseLocation:
            state.isReverseLoadingLocation = false
            state.isErrorReverseLocation = true
            
            
        // MARK: - Bottom View
        case let .setDistanceState(distanceState):
            state.distanceState = distanceState
        case let .setBookMarkIconName(name):
            state.bookMarkIconName = name
            
            
        // MARK: - BookMark Realm
        // Save
        case .setIsLoadingSaveBookMark:
            state.realmBookMarkType = .save(state: .isLoading)
        case .setIsCompleteSaveBookMark:
            state.realmBookMarkType = .save(state: .isComplete)
        case .setIsErrorSaveBookMark:
            state.realmBookMarkType = .save(state: .isError)
        
        // Edit
        case .setIsLoadingEditBookMark:
            state.realmBookMarkType = .edit(state: .isLoading)
        case .setIsCompleteEditBookMark:
            state.realmBookMarkType = .edit(state: .isComplete)
        case .setIsErrorEditBookMark:
            state.realmBookMarkType = .edit(state: .isError)
            
        // Delete
        case .setIsLoadingDeleteBookMark:
            state.realmBookMarkType = .delete(state: .isLoading)
        case .setIsCompleteDeleteBookMark:
            state.realmBookMarkType = .delete(state: .isComplete)
        case .setIsErrorDeleteBookMark:
            state.realmBookMarkType = .delete(state: .isError)
            
        case .setInitRealmBookMark:
            state.realmBookMarkType = .none
            
            
        // MARK: - Transition
        case let .setDestination(location):
            state.destination = location
        }
        
        return state
    }
}
