//
//  BookMarkListActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import ReSwift

struct BookMarkListActionCreator {}

extension BookMarkListActionCreator {
    
    static func fetchBookMarkList(marks: [MarkRealmEntity]) -> ReSwift.Action {
        
        return BookMarkListState.bookMarkListAction.setMarkRealm(markRealm: marks)
    }
    
    static func fetchIsLoadingBookMarkList() -> ReSwift.Action {
        
        return BookMarkListState.bookMarkListAction.setIsLoadingMarkRealm
    }
    
    static func fetchIsErrorBookMarkList() -> ReSwift.Action {
        
        return BookMarkListState.bookMarkListAction.setIsErrorMarkRealm
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
