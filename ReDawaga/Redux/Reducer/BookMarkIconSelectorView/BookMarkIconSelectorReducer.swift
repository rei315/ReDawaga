//
//  BookMarkIconSelectorReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/08.
//

import Foundation
import ReSwift

struct BookMarkIconSelectorReducer {}

extension BookMarkIconSelectorReducer {
    
    static func reduce(action: ReSwift.Action, state: BookMarkIconSelectorState?) -> BookMarkIconSelectorState {
        
        var state = state ?? BookMarkIconSelectorState()
        
        guard let action = action as? BookMarkIconSelectorState.bookMarkIconSelectorAction else {
            return state
        }
        
        switch action {
        
        case .setIsLoadingIconTitles:
            print("setIsLoadingIconTitles")
            state.isLoadingIconTitles = true
            
        case let .setIconTitles(titles):
            print("setIconTitles")
            state.isLoadingIconTitles = false
            state.iconTitles = titles
            state.isErrorLoadingIconTitles = false
            
        case .setIsErrorLoadingIconTitles:
            print("setIsErrorLoadingIconTitles")
            state.isLoadingIconTitles = false
            state.isErrorLoadingIconTitles = true
            
        case let .setSelectedIconTitle(title):
            print("setSelectedIconTitle")
            state.seletecedIconTitle = title
        }
        
        return state
    }
}
