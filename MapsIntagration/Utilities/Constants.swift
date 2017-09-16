//
//  File.swift
//  CallAPI_MVC
//
//  Created by CN354 on 24/05/17.
//  Copyright © 2017 SD. All rights reserved.
//

import Foundation

//# MARK: Struct for Constants
struct Constants {
    //# MARK: Struct for Constants API Request Field Name
    struct APIRequestFieldName {
        static let AccessKey     = "access_key"
        static let TimeStamp     = "timestamp"
        static let Signature     = "signature"
        
        static let Name = "name"
        static let PhoneNumber = "phoneNumber"
    }
    
    //# MARK: Struct for Constants API Response Field Name
    struct APIResponseFieldName {
        static let tripId = "tripid"
        static let from = "from"
        static let to = "to"
    
    }
    
    //# MARK: Struct for Constants API Path
    struct ApiPath {
        static let TripListPath = "triplist.php"
    }
    
    static let NewsAPIKey = "07de3d4786f744fa895838f6d4b9240f"
}
