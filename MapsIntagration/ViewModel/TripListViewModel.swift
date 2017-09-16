//
//  TripListViewModel.swift
//  MapsIntagration
//
//  Created by omnipro2 on 16/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

class TripListViewModel: NSObject {
    func getTrip(onSuccess: @escaping (TripList) -> (), onFailure: @escaping (String) -> ()) {
        NetworkManager.loadTrip() { result in
            print(result ?? [])
            if result != nil {
                onSuccess(result!)
            } else {
                onFailure("Not Get")
            }
        }
    }
    
}
