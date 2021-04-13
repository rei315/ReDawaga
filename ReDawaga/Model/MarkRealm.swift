//
//  MarkRealm.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/29.
//

import Foundation
import SwiftyJSON
import RealmSwift
import PromiseKit

class MarkRealm {
    
    static func getMarkRealmList() -> Promise<[MarkRealmEntity]> {
        return Promise { seal in
            do {
                let realm = try Realm()
                let markItems = realm.objects(MarkRealmEntity.self)
                seal.fulfill(Array(markItems))
            }
            catch {
                seal.reject(error)
                assertionFailure("MarkRealm Error")
            }
        }
    }
    
    static func saveMarkRealm(mark: MarkRealmEntity) -> Promise<Void> {
        return Promise { seal in
            do {
                let realm = try Realm()
                
                try realm.write {
                    realm.add(mark)
                    seal.fulfill(())
                }
            }
            catch {
                seal.reject(error)
            }
        }
    }
    
    static func editMarkRealm(identity: String, name: String = "", address: String = "", iconImage: String = "", latitude: Double = 0, longitude: Double = 0) -> Promise<Bool> {
        return Promise { seal in
            let realm = try Realm()
            guard let data = realm.object(ofType: MarkRealmEntity.self, forPrimaryKey: identity) else {
                seal.fulfill(false)
                return
            }
            
            do {
                try realm.write {
                    let newData = MarkRealmEntity(
                        identity: data.identity,
                        name: name.isEmpty ? data.name : name,
                        latitude: latitude.isZero ? data.latitude : latitude,
                        longitude: longitude.isZero ? data.longitude : longitude,
                        address: address.isEmpty ? data.address : address,
                        iconImageUrl: iconImage.isEmpty ? data.iconImageUrl : iconImage
                    )
                    realm.add(newData, update: .modified)
                    seal.fulfill(true)
                }
            }
            catch {
                seal.reject(error)
            }
        }
    }
    
    static func removeMarkRealm(identity: String) -> Promise<Bool> {
        return Promise { seal in
            let realm = try Realm()
            guard let data = realm.object(ofType: MarkRealmEntity.self, forPrimaryKey: identity) else {
                seal.fulfill(false)
                return
            }
            do {
                try realm.write {
                    realm.delete(data)
                    seal.fulfill(true)
                }
            }
            catch {
                seal.reject(error)
            }
        }
    }
}
