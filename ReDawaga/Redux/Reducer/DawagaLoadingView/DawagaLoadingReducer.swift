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
            
        case let .setNotificationSchedule(error):
            print("setNotificationSchedule")
            state.notificationSchedule = error
        }
        
        return state
    }
}
