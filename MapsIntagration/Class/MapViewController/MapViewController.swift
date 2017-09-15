//
//  MapViewController.swift
//  MapsIntagration
//
//  Created by Omnipro Technologies on 07/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON


enum Location {
    case startLocation
    case destinationLocation
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var LoadingTextLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation?
    var mapUIView       : GMSMapView!
    var placesClient    : GMSPlacesClient!
    var zoomLevel       : Float = 15.0
    
    var AddressValues           = ""
    var ChennaiCurentLocation   = "13.06869 + 80.25692"
    let NCName = Notification.Name(rawValue:"NCCoordinates")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get location
        CLLocationMethod()
        
        // Set Map as Default Location
        setDefaultMapLocation()
        
        placesClient = GMSPlacesClient.shared()
        LoadingTextLabel.animateType(newText: "Loading ...", characterDelay: 1.0)
        NotificationCenter.default.addObserver(forName:NCName, object:nil, queue:nil, using:catchNotification)
        
    }
    
    func CLLocationMethod() {
        
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.delegate        = self
        locationManager.distanceFilter  = 50
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func setDefaultMapLocation() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 13.06869, longitude: 80.25692, zoom: zoomLevel)
        
        mapUIView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapUIView.delegate = self
        mapUIView.settings.myLocationButton = true
        mapUIView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapUIView.isMyLocationEnabled = true  // get Blue Circul in ur location
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapUIView)
        mapUIView.isHidden = true
    }
    
    
    func getLogationAddress(lat : Double, long : Double, handler: @escaping (String) -> Void){
        
        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark?.addressDictionary ?? "")
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            // Street address
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                address += street + ", "
            }
            
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                address += zip + ", "
            }
            
            // Country
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                address += country
            }
            
            // Passing address back
            handler(address)
        })
    }
    
    
    func catchNotification(notification:Notification) -> Void {
        
        setDefaultMapLocation()
        
        guard let userInfo = notification.userInfo,
            var origen        = userInfo["origen"]       as? String,
            var destination   = userInfo["destination"]  as? String else {
                
                print("No userInfo found in notification")
                return
        }
        
        print(origen, destination)
        
        origen      = origen.replacingOccurrences(of: " ", with: "+")
        destination = destination.replacingOccurrences(of: " ", with: "+")
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origen)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapUIView
            }
            
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude : location.coordinate.latitude, longitude : location.coordinate.longitude, zoom : zoomLevel, bearing: 30, viewingAngle : 40)
        
        if mapUIView.isHidden {
            
            mapUIView.isHidden  = false
            mapUIView.camera    = camera
            mapUIView.mapType   = .normal
            
            let marker      = GMSMarker()
            marker.map      = mapUIView
            marker.icon     = UIImage(named: "Map-Pin")!
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            getLogationAddress(lat: location.coordinate.latitude, long: location.coordinate.longitude) { (address) in
                self.AddressValues = address
            }
            
        } else {
            mapUIView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            
        case .denied:
            print("User denied access to location.")
            mapUIView.isHidden = false
            
        case .notDetermined:
            print("Location status not determined.")
            
        case .authorizedAlways: fallthrough
            
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

// For custom Pin Info View
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customInfoWindow = Bundle.main.loadNibNamed("GooglePlaceMarkerInfo", owner: self, options: nil)?[0] as! GooglePlaceMarkerInfo
        customInfoWindow.nameLabel.text = self.AddressValues
        customInfoWindow.placePhoto.image = UIImage(named: "Application-icon")!
        return customInfoWindow
    }
    
}

