//
//  DawagaMapMiddleware.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/04.
//

import ReSwift
import ReSwiftThunk

func thunkSaveBookMark(mark: MarkRealmEntity) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        guard let state = getState() else { return }
        
        if state.dawagaMapState.realmBookMarkType == DawagaMapState.RealmBookMarkType.save(state: .isLoading) {
            return
        }
        
        dispatch(DawagaMapActionCreator.fetchIsLoadingSaveBookMark())
        
        MarkRealm.saveMarkRealm(mark: mark)
            .done {
                dispatch(DawagaMapActionCreator.fetchIsCompleteSaveBookMark())
            }
            .catch { error in
                dispatch(DawagaMapActionCreator.fetchIsErrorSaveBookMark())
            }
    }
}

func thunkEditBookMark(identity: String, name: String, address: String, iconImage: String, latitude: Double, longitude: Double) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        guard let state = getState() else { return }
        
        if state.dawagaMapState.realmBookMarkType == DawagaMapState.RealmBookMarkType.edit(state: .isLoading) {
            return
        }
        
        dispatch(DawagaMapActionCreator.fetchIsLoadingEditBookMark())
        
        MarkRealm.editMarkRealm(identity: identity, name: name, address: address, iconImage: iconImage, latitude: latitude, longitude: longitude)
            .done { isSuccess in
                if isSuccess {
                    dispatch(DawagaMapActionCreator.fetchIsCompleteEditBookMark())
                }
                else {
                    dispatch(DawagaMapActionCreator.fetchIsErrorEditBookMark())
                }                
            }
            .catch { error in
                dispatch(DawagaMapActionCreator.fetchIsErrorEditBookMark())
            }
    }
}

func thunkDeleteBookMark(identity: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        guard let state = getState() else { return }
        
        if state.dawagaMapState.realmBookMarkType == DawagaMapState.RealmBookMarkType.delete(state: .isLoading) {
            return
        }
        
        dispatch(DawagaMapActionCreator.fetchIsLoadingDeleteBookMark())
        
        MarkRealm.removeMarkRealm(identity: identity)
            .done { isSuccess in
                if isSuccess {
                    dispatch(DawagaMapActionCreator.fetchIsCompleteDeleteBookMark())
                }
                else {
                    dispatch(DawagaMapActionCreator.fetchIsErrorDeleteBookMark())
                }
            }
            .catch { error in
                dispatch(DawagaMapActionCreator.fetchIsErrorDeleteBookMark())
            }
    }
}
