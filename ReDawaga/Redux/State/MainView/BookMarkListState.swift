//
//  BookMarkListState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import ReSwift

struct BookMarkListState: ReSwift.StateType {
    
    // MARK: - BookMark List View
    
    var isLoadingMarkRealm: Bool = false
    
    var markRealm: [MarkRealmEntity] = []
    
    var isErrorMarkRealm: Bool = false
    
    
    // MARK: - Search View
    
    var searchAddress: String = ""
    
    
    // MARK: - When Transition Parameters
    
    var transitionType: DawagaMapViewController.TransitionType = .Quick        
    
    var bookMark: MarkRealmEntity? = nil
}
