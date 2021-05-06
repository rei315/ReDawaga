//
//  NetworkMonitorActionCreator.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/06.
//

import Foundation
import ReSwift

struct NetworkMonitorActionCreator {}

extension NetworkMonitorActionCreator {

    static func fetchIsConnected(isConnected: Bool) {
        appStore.dispatch(NetworkMonitorState.networkMonitorAction.setIsConnected(isConnected: isConnected))
    }
}
