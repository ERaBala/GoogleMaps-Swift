//
//  MapMainViewController.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 08/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

class MapMainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var OrigenTextField      : UITextField!
    @IBOutlet weak var DestinationTextField : UITextField!
    
    let NCName = Notification.Name(rawValue:"NCCoordinates")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.OrigenTextField.text = UserDefaults.standard.string(forKey: "from")
        self.DestinationTextField.text = UserDefaults.standard.string(forKey: "to")
        UserDefaults.standard.string(forKey: "to")
        self.OrigenTextField.delegate = self
        self.DestinationTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapMainViewController.dismissKeyboard))
        self.navigationItem.title = "Map"
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
         ShowDirections()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == OrigenTextField {
            DestinationTextField.becomeFirstResponder()
        }else if textField == DestinationTextField {
             self.view.endEditing(true)
              ShowDirections()
        }
        return true
        
    }
    
    func ShowDirections(){
        
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
