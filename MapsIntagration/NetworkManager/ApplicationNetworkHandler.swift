//
//  ApplicationNetworkHandler.swift
//  APICAllWithMVC
//
//  Created by CN354 on 23/05/17.
//  Copyright © 2017 SD. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    //# MARK: Call Class Function to Get the list of news
    class func loadTrip(completion: @escaping (TripList?) -> Void)->Void {
        let parse : (_ fetchedData : Data)->TripList? = {fetchedData in
            
            if let jsonDict = NetworkManager.decodeJSON(data: fetchedData as Data) {
                let newsArr = jsonDict["triplist"] as! [[String:AnyObject]]
                if let tripOBJ = TripList.createTrip(tripInfo: newsArr[0]) as TripList? {
                    return tripOBJ
                } else {
                    return nil
                }
            }
            else
            {
                return nil
            }
        }
        
        self.apiRequest(resource: ApplicationNetworkResource<Any>(method: ApplicationRequestHTTPMethod.GET, path: Constants.ApiPath.TripListPath, params: nil, parse: parse)) { (result, error)  in
            if let result = result {
                completion(result as? TripList)
            } else {
                if error != nil {
                    completion(nil)
                }
            }
        }
    }
}
