//
//  BookMarkIconSelectorAction.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/08.
//

import Foundation
import ReSwift

extension BookMarkIconSelectorState {
    
    enum bookMarkIconSelectorAction: ReSwift.Action {
        
        case setIsLoadingIconTitles
        
        case setIconTitles(titles: [String])
        
        case setIsErrorLoadingIconTitles
        
        case setSelectedIconTitle(title: String)
    }
}
