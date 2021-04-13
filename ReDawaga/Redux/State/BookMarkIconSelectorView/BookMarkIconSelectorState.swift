//
//  BookMarkIconSelectorState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/08.
//

import Foundation
import ReSwift

struct BookMarkIconSelectorState: ReSwift.StateType {
    
    var isLoadingIconTitles: Bool = false
    
    var iconTitles: [String] = []
    
    var isErrorLoadingIconTitles: Bool = false
    
    var seletecedIconTitle: String = ""
}
