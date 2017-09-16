//
//  LoginViewController.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 07/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "GoogleMaps", bundle:nil)
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "RouteListViewController") as! RouteListViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
