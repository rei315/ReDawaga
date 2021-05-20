//
//  ReduxAPIManagerForGoogleMaps.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/03.
//

import ReSwift
import ReSwiftThunk
import CoreLocation

func thunkFetchAutoCompleteList(_ address: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        guard let state = getState() else { return }
        
        if state.placeSearchState.isLoadingPlace {
            return
        }
        
        dispatch(PlaceSearchActionCreator.fetchIsLoadingPlace())
        
        APIManagerForGoogleMaps.shared.getAutoCompleteList(address: address)
            .done { placeJSON in
                let places = Place.getPlaceListBy(json: placeJSON)
                dispatch(PlaceSearchActionCreator.fetchPlaceList(placeList: places))
            }
            .catch { error in
                dispatch(PlaceSearchActionCreator.fetchIsErrorPlace())
            }
    }
}

func thunkFetchSearchLocation(_ id: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        guard let state = getState() else { return }
        
        if state.dawagaMapState.isSearchLoadingLocation {
            return
        }
        
        appStore.dispatch(DawagaMapActionCreator.fetchIsLoadingSearchLocation())
        
        APIManagerForGoogleMaps.shared.getPlaceDetails(placeId: id)
            .done { detailJSON in
                let location = Location.getLocationBy(json: detailJSON)
                dispatch(DawagaMapActionCreator.fetchSearchLocation(location: location))
            }
            .catch { error in
                appStore.dispatch(DawagaMapActionCreator.fetchIsErrorSearchLocation())
            }
    }
}

func thunkFetchReverseLocation(_ location: CLLocation) -> Thunk<AppState> {
    
    return Thunk<AppState> { dispatch, getState in
        guard let state = getState() else { return }
        
        if state.dawagaMapState.isReverseLoadingLocation {
            return
        }
        
        appStore.dispatch(DawagaMapActionCreator.fetchIsLoadingReverseLocation())
        
        APIManagerForGoogleMaps.shared.getReverseGeocode(location: location)
            .done { detailJSON in
                let location = Location.getLocationBy(json: detailJSON)
                let title = location.title
                appStore.dispatch(DawagaMapActionCreator.fetchReverseGeocode(location: title))
            }
            .catch { error in
                appStore.dispatch(DawagaMapState.dawagaMapAction.setIsErrorReverseLocation)
            }
    }
}
