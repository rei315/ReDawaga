//
//  BookMarkListAction.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import ReSwift

extension BookMarkListState {
    
    enum bookMarkListAction: ReSwift.Action {
        
        // MARK: - BookMark List View
        
        case setIsLoadingMarkRealm
        
        case setMarkRealm(markRealm: [MarkRealmEntity])
        
        case setIsErrorMarkRealm
        
        
        // MARK: - Search View
        
        case setSearchAddress(address: String)
        
        
        // MARK: - When Transition Parameters
        
        case setTransitionType(type: DawagaMapViewController.TransitionType)                
        
        case setBookMark(mark: MarkRealmEntity)
        
    }
}
