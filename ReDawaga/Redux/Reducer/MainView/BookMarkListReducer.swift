//
//  BookMarkListReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import ReSwift

struct BookMarkListReducer {}

extension BookMarkListReducer {
    
    static func reduce(action: ReSwift.Action, state: BookMarkListState?) -> BookMarkListState {
        
        var state = state ?? BookMarkListState()
        
        guard let action = action as? BookMarkListState.bookMarkListAction else { return state }
        
        switch action {
            
        case .setIsLoadingMarkRealm:
            print("setIsLoadingMarkRealm")
            state.isLoadingMarkRealm = true
            
        case let .setMarkRealm(markRealm):
            print("setMarkRealm")
            state.isLoadingMarkRealm = false
            state.markRealm = markRealm
            state.isErrorMarkRealm = false
        
        case .setIsErrorMarkRealm:
            print("setIsErrorMarkRealm")
            state.isLoadingMarkRealm = false
            state.isErrorMarkRealm = true
            
        case let .setSearchAddress(address):
            print("setSearchAddress")
            state.searchAddress = address
            
        case let .setTransitionType(type):
            print("setTransitionType")
            state.transitionType = type
        
        case let .setBookMark(mark):
            print("setBookMark")
            state.bookMark = mark

        }
                                        
        return state
    }
}
