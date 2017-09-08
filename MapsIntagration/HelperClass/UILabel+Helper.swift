//
//  ExtensionHelperClass.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 08/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

extension UILabel {
    
    func animateType(newText: String, characterDelay: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.text = ""
            
            for (index, character) in newText.characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
}
