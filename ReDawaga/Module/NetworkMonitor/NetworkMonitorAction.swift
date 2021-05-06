//
//  NetworkMonitorAction.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/06.
//

import Foundation
import ReSwift

extension NetworkMonitorState {
    
    enum networkMonitorAction: ReSwift.Action {
        
        case setIsConnected(isConnected: Bool)
    }
}
