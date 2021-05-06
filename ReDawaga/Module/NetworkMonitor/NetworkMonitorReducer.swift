//
//  NetworkMonitorReducer.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/06.
//

import Foundation
import ReSwift

struct NetworkMonitorReducer{}

extension NetworkMonitorReducer {
    
    static func reduce(action: ReSwift.Action, state: NetworkMonitorState?) -> NetworkMonitorState {
        
        var state = state ?? NetworkMonitorState()
        
        guard let action = action as? NetworkMonitorState.networkMonitorAction else { return state }
        
        switch action {
        case let .setIsConnected(isConnected):
            state.isConnected = isConnected
        }
        
        return state
    }
}
