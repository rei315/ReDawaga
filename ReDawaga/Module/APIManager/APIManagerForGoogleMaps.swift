//
//  APIManagerForGoogleMaps.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON
import CoreLocation

class APIManagerForGoogleMaps {
    
    private let AutoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    private let DetailUrl = "https://maps.googleapis.com/maps/api/place/details/json"
    private let ReverseGeocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    
    private let key = Constants.GOOGLE_API_KEY
    
    
    // MARK: - Singleton Instance
    
    static let shared = APIManagerForGoogleMaps()
    
    private init() {}

    
    // MARK: - Function

    func getAutoCompleteList(address: String) -> Promise<JSON> {
        
        
        let parameters: [String : Any] = [
            "input"     :   address,
            "types"     :   "geocode|establishment",
            "key"       :   key
        ]
        
        return Promise { seal in
            AF.request(AutoCompleteUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let res = JSON(value)
                    let json = res["predictions"]                    
                    seal.fulfill(json)
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }                
        }
    }
    
    func getPlaceDetails(placeId: String) -> Promise<JSON> {
        
        let parameters: [String : Any] = [
            "place_id"  :   placeId,
            "key"       :   key
        ]
        
        return Promise { seal in
            AF.request(DetailUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let res = JSON(value)
                    let json = res["result"]
                    seal.fulfill(json)
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func getReverseGeocode(location: CLLocation) -> Promise<JSON> {
        
        let parameters: [String : Any] = [
            "latlng"            :      "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "key"               :      key,
            "location_type"     :      "ROOFTOP"
        ]
        
        return Promise { seal in
            AF.request(ReverseGeocodeUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let res = JSON(value)
                    
                    if let json = res["results"].arrayValue.first {
                        seal.fulfill(json)
                    }
                    else {
                        let error: AFError.ResponseValidationFailureReason = .dataFileNil
                        seal.reject(AFError.responseValidationFailed(reason: error))
                    }
                                        
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
