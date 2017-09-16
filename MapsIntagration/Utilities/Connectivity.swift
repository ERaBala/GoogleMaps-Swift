//
//  Connectivity.swift
//  F-First-Firstbaby
//
//  Created by CN354 on 16/05/17.
//  Copyright © 2017 SD. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity: NSObject {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
