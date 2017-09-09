//
//  MapMainViewController.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 08/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

class MapMainViewController: UIViewController {

    @IBOutlet weak var OrigenTextField      : UITextField!
    @IBOutlet weak var DestinationTextField : UITextField!
    
    let NCName = Notification.Name(rawValue:"NCCoordinates")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapMainViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    
    @IBAction func ShowDirections(_ sender: Any) {
        
        guard let origen = self.OrigenTextField.text, let destination = self.DestinationTextField.text, origen.characters.count > 2, destination.characters.count > 2  else {
            print("Enter the Text field Values")
            return
        }
        NotificationCenter.default.post(name:NCName, object: nil, userInfo:["origen":origen, "destination":destination])
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
