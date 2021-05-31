//
//  APITests.swift
//  ReDawagaTests
//
//  Created by 김민국 on 2021/05/27.
//

import XCTest
import CoreLocation
@testable import ReDawaga

class APITests: XCTestCase {

    let autoCompleteTest: [String] = [
        "우정동",
        "부산진구",
        "동의대"
    ]
    
    let searchLocationTest: [String] = [
        "ChIJnUOsfdAyZjURgGJm-pfvhcw",
        "ChIJxc1SrxXraDURYOhd41aQa4Y",
        "ChIJJ92MZLHraDUR_z5czO4D6CU",
    ]
    
    let reverseLocationTest: [CLLocation] = [
        CLLocation(latitude: 35.55473651, longitude: 129.31235902),
        CLLocation(latitude: 35.16300096, longitude: 129.05317213),
        CLLocation(latitude: 35.14296799, longitude: 129.03409090)
    ]
                

    func testThunkFetchAutoCompleteList() throws {
        let expectation = XCTestExpectation()
        
        appStore.dispatch(thunkFetchAutoCompleteList(autoCompleteTest[0]))
        
        if appStore.state.placeSearchState.isLoadingPlace {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3)
        
        let isAvailable = appStore.state.placeSearchState.placeList.isEmpty ? false : true
        XCTAssertTrue(isAvailable, "ThunkFetchAutoCompleteList is not available")
    }
    
    func testThunkFetchSearchLocation() throws {
        let expectation = XCTestExpectation()
        appStore.dispatch(thunkFetchSearchLocation(searchLocationTest[0]))
        
        if appStore.state.dawagaMapState.isLoadingSearchLocation {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
        
        let isAvailable = appStore.state.dawagaMapState.searchLocationDetail
        XCTAssertNotNil(isAvailable, "ThunkFetchSearchLocation is not available")
    }

    func testThunkFetchReverseLocation() throws {
        let expectation = XCTestExpectation()
        appStore.dispatch(thunkFetchReverseLocation(reverseLocationTest[0]))
        
        if appStore.state.dawagaMapState.isLoadingReverseLocation {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
        
        let isAvailable = appStore.state.dawagaMapState.reverseLocationDetail == "" ? false : true
        XCTAssertNotNil(isAvailable, "ThunkFetchReverseLocation is not available")
    }
}
