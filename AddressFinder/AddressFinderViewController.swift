//
//  ViewController.swift
//  AddressFinder
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddressFinderViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UITextField!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var previousPoint: CLLocation?
    
    // How far do you move (in meters) before you receive an update
    fileprivate var totalMovementDistance = CLLocationDistance(0)
    
    @IBAction func searchForLocation(_ sender: Any) {
        // Create a Coordinate Locator
        let geoCoder = CLGeocoder()
        var coords: CLLocationCoordinate2D?
        
        // Determine the zoom level of the map to display
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        geoCoder.geocodeAddressString(address.text!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemark = placemarks?[0] {
                // Convert the address to a coordinate
                let location = placemark.location
                coords = location!.coordinate
                
                // Set the map to the coordinate
                let region = MKCoordinateRegion(center: coords!, span: span)
                self.mapView.region = region
                
                // Add a pin to the address location
                self.mapView.addAnnotation(MKPlacemark (placemark: placemark))
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // How often do you want to receive updates
        locationManager.distanceFilter = 50
        
        // Before your application can use location services, you need to get the user's permission to do so
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension AddressFinderViewController: CLLocationManagerDelegate {
    private func locationManager(_ manager: CLLocationManagerDelegate, didChangeAuthorization status: CLAuthorizationStatus) {
        print ("Authhorization status changed to\(status.rawValue)")
        
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            default:
                locationManager.stopUpdatingLocation()
                mapView.showsUserLocation = false
        }
    }
}
