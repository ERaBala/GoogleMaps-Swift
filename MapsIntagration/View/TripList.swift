//
//  TripList.swift
//  MapsIntagration
//
//  Created by omnipro2 on 16/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import Foundation
class TripList {
    var tripId: String = ""
    var from: String = ""
    var to: String = ""

    init(tripId: String, from: String, to: String) {
        self.tripId = tripId
        self.from = from
        self.to = to
    }
    
    class func createTrip(tripInfo: JSONDictionary) -> TripList? {
        let tripId = tripInfo[Constants.APIResponseFieldName.tripId] as? String
        guard (tripId != nil) else{
            return nil
        }
        
        let fromAdd = tripInfo[Constants.APIResponseFieldName.from] as? String
        guard (fromAdd != nil) else{
            return nil
        }
        
        let toAdd = tripInfo[Constants.APIResponseFieldName.to] as? String
        guard (toAdd != nil) else{
            return nil
        }
        
        return TripList(tripId: tripId!, from: fromAdd!, to: toAdd!)
    }
    
    /*class func createTripList(jsonDict: JSONDictionary) -> [TripList] {
        var listOfTrips = [TripList]()
            for trip in jsonDict {
                if let trips = TripList.createTrip(tripInfo: trip) {
                    listOfTrips.append(trips)
                }
            }
        return listOfTrips
    }*/
    
}
