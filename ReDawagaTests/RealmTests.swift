//
//  RealmTests.swift
//  ReDawagaTests
//
//  Created by 김민국 on 2021/05/27.
//

import XCTest
import RealmSwift
@testable import ReDawaga

class RealmTests: XCTestCase {

    let testRealm: [MarkRealmEntity] = [
        MarkRealmEntity(identity: "\(Date())", name: "우정동", latitude: 35.55473651, longitude: 129.31235902, address: "우정동", iconImageUrl: "mark00000.png"),
        MarkRealmEntity(identity: "\(Date())", name: "부산진구", latitude: 35.16300096, longitude: 129.05317213, address: "부산진구", iconImageUrl: "mark00001.png"),
        MarkRealmEntity(identity: "\(Date())", name: "동의대", latitude: 35.14296799, longitude: 129.03409090, address: "동의대", iconImageUrl: "mark00002.png"),
    ]
        
    override func setUpWithError() throws {
        appStore.dispatch(thunkFetchBookMarkList)
    }

    override func tearDownWithError() throws {
        
    }
        
    func testRemoveAllRealm() throws {
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.deleteAll()
            }
        } catch {
                // handle error
            XCTAssertTrue(false, "testRemoveAllRealm")
        }

        XCTAssertTrue(true, "testRemoveAllRealm")
    }
    
    func testCheckRealmIsAvailable() throws {
        
        let isErrorLoadingRealm = !appStore.state.bookMarkListState.isErrorMarkRealm
        
        XCTAssertTrue(isErrorLoadingRealm, "Loading BookMarkList-Realm was Error")
    }
    
    func testAddRealmExample() throws {

        appStore.dispatch(thunkSaveBookMark(mark: testRealm[0]))
        
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            if appStore.state.dawagaMapState.realmBookMarkType == .save(state: .isComplete) {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2)
        
        switch appStore.state.dawagaMapState.realmBookMarkType {
        case let .save(type):
            let isComplete = type == .isComplete ? true : false
            XCTAssertTrue(isComplete, "Save Realm is not working well")
        default:
            XCTAssertTrue(false, "Edit Realm is not working well")
        }
    }

    func testEditRealmExample() throws {
        
        let firstRealm = appStore.state.bookMarkListState.markRealm.first
        XCTAssertNotNil(firstRealm, "realm is nil")

        guard let identity = firstRealm?.identity else { return }

        appStore.dispatch(thunkEditBookMark(identity: identity, name: testRealm[1].name, address: testRealm[1].address, iconImage: testRealm[1].iconImageUrl, latitude: testRealm[1].latitude, longitude: testRealm[1].longitude))
        
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            if appStore.state.dawagaMapState.realmBookMarkType == .edit(state: .isComplete) {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2)
        
        switch appStore.state.dawagaMapState.realmBookMarkType {
        case let .edit(type):
            let isComplete = type == .isComplete ? true : false
            XCTAssertTrue(isComplete, "Edit Realm is not working well")
        default:
            XCTAssertTrue(false, "Edit Realm is not working well")
        }
    }

    func testDeleteRealmExample() throws {
        
//        let expectation = XCTestExpectation()
//
//        let firstMark = appStore.state.bookMarkListState.markRealm.first
//        XCTAssertNotNil(firstMark, "realm is nil")
//
//        guard let mark = firstMark else { return }
//
//        appStore.dispatch(thunkDeleteBookMark(identity: mark.identity))

//        switch appStore.state.dawagaMapState.realmBookMarkType {
//        case let .delete(type):
//            let isComplete = type == .isComplete ? true : false
//            XCTAssertTrue(isComplete, "Delete Realm is not working well")
//        default:
//            break
//        }
    }
}
