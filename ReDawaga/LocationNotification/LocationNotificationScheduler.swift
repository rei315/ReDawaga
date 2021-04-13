//
//  LocationNotificationScheduler.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import CoreLocation
import UserNotifications

class LocationNotificationScheduler: NSObject {
    
    func request(with notificationInfo: LocationNotificationEntity) {
        askForNotificationPermissions(notificationInfo: notificationInfo)
    }
}

// MARK: - Private Functions
private extension LocationNotificationScheduler {
    
    func askForNotificationPermissions(notificationInfo: LocationNotificationEntity) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    DawagaLoadingActionCreator.fetchIsNotificationPermissionDenied()
                    return
                }
                self?.requestNotification(notificationInfo: notificationInfo)
        })
    }
    
    func requestNotification(notificationInfo: LocationNotificationEntity) {
        let notification = notificationContent(notificationInfo: notificationInfo)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: notificationInfo.notificationId,
                                            content: notification,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            DawagaLoadingActionCreator.fetchNotificationSchedule(error: error)
        }
    }
    
    func notificationContent(notificationInfo: LocationNotificationEntity) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        notification.badge = 1
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        return notification
    }
}
