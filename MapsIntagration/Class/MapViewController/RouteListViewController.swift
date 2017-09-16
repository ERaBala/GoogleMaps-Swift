//
//  RouteListViewController.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 07/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit

class RouteListViewController: UIViewController {

    var tripViewModel = TripListViewModel()
    @IBOutlet weak var tableView: UITableView!
    var tripListArray = [TripList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Route List"
        let nib = UINib(nibName: "RouteListTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "RouteListTableViewCell")
        
        if Connectivity.isConnectedToInternet() {
            tripViewModel.getTrip(onSuccess: { (tripListResults) in
                print(tripListResults)
                self.tripListArray = [tripListResults]
                self.tableView.reloadData()
            }, onFailure: { (error) in
                print(error)
            })
        } else {
            print("No Internet connection")
        }
        // Do any additional setup after loading the view.
    }

}

extension RouteListViewController: UITableViewDelegate, UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.tripListArray.count)
        return self.tripListArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListTableViewCell", for: indexPath) as! RouteListTableViewCell
        cell.tripId.text = self.tripListArray[indexPath.row].tripId
        cell.fromAddress.text = self.tripListArray[indexPath.row].from
        cell.toAddress.text = self.tripListArray[indexPath.row].to
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let from = self.tripListArray[indexPath.row].from
        let to = self.tripListArray[indexPath.row].to
        UserDefaults.standard.set(from, forKey: "from") //setObject
        UserDefaults.standard.set(to, forKey: "to") //setObject
        let storyBoard : UIStoryboard = UIStoryboard(name: "GoogleMaps", bundle:nil)
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "MapMainViewController") as! MapMainViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
