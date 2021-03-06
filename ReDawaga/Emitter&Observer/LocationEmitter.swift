//
//  LocationEmitter.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import CoreLocation
import ReSwift

final class LocationEmitter: NSObject {
    
    // MARK: - Singleton Instance
    
    static let shared = LocationEmitter()
    
    
    // MARK: - Property
    
    private let locationManager: CLLocationManager
    
    enum EmitterType {
        case OneTime, EveryTime
    }
    private var emitterType: EmitterType = .OneTime
    
    
    // MARK: - Lifecycle

    override init() {
        
        self.locationManager = CLLocationManager()
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.requestAlwaysAuthorization()
    }


    // MARK: - Function

    private func dispatch(authorizationStatus: CLAuthorizationStatus) {
        LocationEmitterActionCreator.fetchAuthorizationStatus(state: authorizationStatus)
    }

    private func dispatch(location: CLLocation?) {
        LocationEmitterActionCreator.fetchLocation(location: location)
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
    func startUpdatingLocation(type: EmitterType) {
        self.emitterType = type
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        dispatch(location: nil)
        self.locationManager.stopUpdatingLocation()
    }
}

extension LocationEmitter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        dispatch(authorizationStatus: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        dispatch(location: locations.last)
        if emitterType == .OneTime {
            stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        LogHelper(data: "didFailWithError")
    }
}
