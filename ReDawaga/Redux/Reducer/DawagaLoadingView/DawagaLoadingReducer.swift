//
//  DawagaLoadingReducer.swift.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import ReSwift

struct DawagaLoadingReducer {}

extension DawagaLoadingReducer {
    
    static func reduce(action: ReSwift.Action, state: DawagaLoadingState?) -> DawagaLoadingState {
        
        var state = state ?? DawagaLoadingState()
        
        guard let action = action as? DawagaLoadingState.dawagaLoadingAction else {
            return state
        }
        
        switch action {
        case .setIsNotificationPermissionDenied:
            print("setIsNotificationPermissionDenied")
            state.isNotificationPermissionDenied = true
            
        case let .setNotificationScheduleError(error):
            print("setNotificationSchedule")
            state.notificationScheduleError = error
            
        case .setNotificationScheduled:
            state.notificatinoScheduled = true
            
        case let .setIsStartDawaga(isStart):
            state.isStartDawaga = isStart
            state.notificationScheduleError = nil
            state.notificatinoScheduled = false
        }
        
        return state
    }
}
