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
        if error == nil{
            appStore.dispatch(DawagaLoadingState.dawagaLoadingAction.setNotificationScheduled)
        }
        else {
            appStore.dispatch(DawagaLoadingState.dawagaLoadingAction.setNotificationScheduleError(error: error))
        }
    }
    
    static func fetchIsStartDawaga(isStart: Bool) {
        appStore.dispatch(DawagaLoadingState.dawagaLoadingAction.setIsStartDawaga(isStart: isStart))
    }
}
