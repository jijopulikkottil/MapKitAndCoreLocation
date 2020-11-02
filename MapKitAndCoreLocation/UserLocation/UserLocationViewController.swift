//
//  UserLocationViewController.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 13/09/20.
//  Copyright © 2020 mVoc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
//https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services
//https://developer.apple.com/documentation/corelocation

class UserLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let regionInMeters = 10000.0
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.initializeWithLocationUpdate(delegate: self)
        mapView.showsUserLocation = true
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

}

extension UserLocationViewController: LocationUpdateDelegate {
    func updateToLocation(_ location: CLLocationCoordinate2D) {
        centerViewOnUserLocation()
    }
}
