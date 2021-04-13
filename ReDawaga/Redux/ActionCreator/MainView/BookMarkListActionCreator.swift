//
//  BookMarkListActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import Foundation

struct BookMarkListActionCreator {}

extension BookMarkListActionCreator {
    
    static func fetchBookMarkList() {
        
        appStore.dispatch(BookMarkListState.bookMarkListAction.setIsLoadingMarkRealm)
        
        MarkRealm.getMarkRealmList()
            .done { marks in
                appStore.dispatch(BookMarkListState.bookMarkListAction.setMarkRealm(markRealm: marks))
            }
            .catch { error in
                appStore.dispatch(BookMarkListState.bookMarkListAction.setIsErrorMarkRealm)
            }
    }
    
    static func fetchBookMarkListClear() {
        appStore.dispatch(BookMarkListState.bookMarkListAction.setMarkRealm(markRealm: []))
    }

    static func fetchSearchAddress(address: String) {
        appStore.dispatch(BookMarkListState.bookMarkListAction.setSearchAddress(address: address))
    }
    
    static func fetchTransitionType(type: DawagaMapViewController.TransitionType) {
        appStore.dispatch(BookMarkListState.bookMarkListAction.setTransitionType(type: type))
    }
    
    
    
    static func fetchBookMark(mark: MarkRealmEntity?) {
        guard let mark = mark else { return }
        appStore.dispatch(BookMarkListState.bookMarkListAction.setBookMark(mark: mark))
    }
}
