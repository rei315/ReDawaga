//
//  BookMarkIconSelectorActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/08.
//

import Foundation

struct BookMarkIconSelectorActionCreator {}

extension BookMarkIconSelectorActionCreator {
    
    static func fetchIconTitles() {
        ResourceManager.shared.fetchMarkIcons()
            .done { titles in
                appStore.dispatch(BookMarkIconSelectorState.bookMarkIconSelectorAction.setIsLoadingIconTitles)
                appStore.dispatch(BookMarkIconSelectorState.bookMarkIconSelectorAction.setIconTitles(titles: titles))
            }
            .catch { error in
                appStore.dispatch(BookMarkIconSelectorState.bookMarkIconSelectorAction.setIsErrorLoadingIconTitles)
            }
    }
    
    static func fetchSelectedTitle(title: String) {
        appStore.dispatch(BookMarkIconSelectorState.bookMarkIconSelectorAction.setSelectedIconTitle(title: title))
    }
}
