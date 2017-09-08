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

class MapViewController: UIViewController {
    
    @IBOutlet weak var LoadingTextLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation?
    var mapUIView       : GMSMapView!
    var placesClient    : GMSPlacesClient!
    var zoomLevel       : Float = 15.0
    
    var ChennaiCurentLocation = "13.06869 + 80.25692"
    
    // An array to hold the list of likely places.
    var likelyPlaces    : [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace   : GMSPlace?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get location
        CLLocationMethod()
        
        // Set Map as Default Location
        setDefaultMapLocation()
        
        LoadingTextLabel.animateType(newText: "Loading ...", characterDelay: 0.8)
        
    }
    
    func CLLocationMethod() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    func setDefaultMapLocation() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: zoomLevel)
        
        mapUIView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapUIView.settings.myLocationButton = true
        mapUIView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapUIView.delegate = self
        // mapUIView.isMyLocationEnabled = true  // get Blue Circul in ur location
        
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
    
    
    func getAddress(lat : String, handler: (String) -> Void)
    {
        handler("Emty string But Some value is Return \(lat)")
    }
    
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude  : location.coordinate.latitude,
                                              longitude     : location.coordinate.longitude,
                                              zoom          : zoomLevel,
                                              bearing       : 30,
                                              viewingAngle  : 40)
        
        // MANUAL DIRECTIONS START
        
        let path = GMSMutablePath()
        path.addLatitude(13.06677, longitude:80.25405) // Sydney
        path.addLatitude(13.07324, longitude:80.26092) // Fiji
        path.addLatitude(13.06819, longitude:80.27156) // Hawaii
        path.addLatitude(13.06196, longitude:80.26293) // Mountain View
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.map = mapUIView
        
        // MANUAL DIRECTIONS END

        if mapUIView.isHidden {
            
            mapUIView.isHidden = false
            mapUIView.camera = camera
            mapUIView.mapType = .satellite
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            getAddress(lat: "0.0 lat") { (address) in
                print(address)
            }
            
            getLogationAddress(lat: location.coordinate.latitude, long: location.coordinate.longitude) { (address) in
                print(address)
            }
            
            // marker.title = address
            // marker.iconView = customInfoWindow
            // marker.snippet = "Australia"
            marker.map = mapUIView
            
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
            // Display the map using the default location.
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
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customInfoWindow = Bundle.main.loadNibNamed("GooglePlaceMarkerInfo", owner: self, options: nil)?[0] as! GooglePlaceMarkerInfo
        customInfoWindow.nameLabel.text = "HI Bala Murugan"
        customInfoWindow.placePhoto.image = UIImage(named: "Application-icon")!
        return customInfoWindow
    }
    
}

// CHECK FOR DIRECTIONS
// https://github.com/balitax/Google-Maps-Direction
