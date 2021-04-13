//
//  DawagaLoadingState.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import Foundation
import ReSwift
import UserNotifications

struct DawagaLoadingState: ReSwift.StateType {
    
    var isNotificationPermissionDenied: Bool = false
    
    var notificationSchedule: Error? = nil
}
