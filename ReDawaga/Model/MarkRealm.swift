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
}
