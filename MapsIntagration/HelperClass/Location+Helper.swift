//
//  Location+Helper.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 09/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

extension String {

    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }

}
