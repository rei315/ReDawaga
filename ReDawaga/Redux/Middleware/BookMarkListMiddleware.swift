//
//  BookMarkListMiddleware.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/03.
//

import ReSwift
import ReSwiftThunk

let thunkFetchBookMarkList = Thunk<AppState> { dispatch, getState in
    
    guard let state = getState() else { return }
    
    if state.bookMarkListState.isLoadingMarkRealm {
        return
    }
    
    dispatch(BookMarkListActionCreator.fetchIsLoadingBookMarkList())
    
    MarkRealm.getMarkRealmList()
        .done { marks in
            appStore.dispatch(BookMarkListActionCreator.fetchBookMarkList(marks: marks))
        }
        .catch { error in
            appStore.dispatch(BookMarkListActionCreator.fetchIsErrorBookMarkList())
        }
}
