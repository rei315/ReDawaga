//
//  DawagaLoadingAction.swift.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import ReSwift

extension DawagaLoadingState {
    
    enum dawagaLoadingAction: ReSwift.Action {

        case setIsNotificationPermissionDenied
        
        case setNotificationScheduleError(error: Error?)
        
        case setNotificationScheduled        
        
        case setIsStartDawaga(isStart: Bool)
    }
}
