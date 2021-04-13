//
//  DawagaLoadingActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation

struct DawagaLoadingActionCreator {}

extension DawagaLoadingActionCreator {

    static func fetchIsNotificationPermissionDenied() {
        appStore.dispatch(DawagaLoadingState.dawagaLoadingAction.setIsNotificationPermissionDenied)
    }
    
    static func fetchNotificationSchedule(error: Error?) {
        appStore.dispatch(DawagaLoadingState.dawagaLoadingAction.setNotificationSchedule(error: error))
    }
}
