//
//  GeoFenceViewController.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 14/09/20.
//  Copyright © 2020 mVoc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
//https://developer.apple.com/documentation/corelocation/monitoring_the_user_s_proximity_to_geographic_regions

class GeoFenceViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let regionInMeters = 100000.0
    // Create a location manager to trigger user tracking
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.initializeWithLocationUpdate(delegate: self)
        locationManager.regionMonitoringDelegate = self

        mapView.showsUserLocation = true
        mapView.delegate = self
        
        //19.0760° N, 72.8777° E mumbai
        let coordinate = CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777)
        locationManager.monitorRegionAtLocation(center: coordinate, identifier: "Mumbai", radius: 8000.0)
        
        //Circle overlay - MKCircle
        let circle = MKCircle(center: coordinate, radius: 8000.0)
        mapView?.addOverlay(circle)

        //new mumbai 19.0330° N, 73.0297° E
        let coordinate2 = CLLocationCoordinate2D(latitude: 19.0330, longitude: 73.0297)
        locationManager.monitorRegionAtLocation(center: coordinate2, identifier: "Navi Mumbai", radius: 8000.0)
        
        //Circle overlay - MKCircle
        let circle2 = MKCircle(center: coordinate2, radius: 8000.0)
        mapView?.addOverlay(circle2)
        
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension GeoFenceViewController: LocationUpdateDelegate {
    func updateToLocation(_ location: CLLocationCoordinate2D) {
        centerViewOnUserLocation()
    }
}

extension GeoFenceViewController: RegionMonitoringDelegate {

    func enteredToRegion(identifier: String) {
        print("didEnterRegion identifier = \(identifier)")
    }
    
    func exitedFromRegion(identifier: String) {
        print("didExitRegion identifier \(identifier)")
    }
}


extension GeoFenceViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if overlay is MKCircle {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.lineWidth = 1
        circleView.strokeColor = UIColor.red
        circleView.fillColor = UIColor.red.withAlphaComponent(0.3)
        return circleView
        
      }
      return MKOverlayRenderer()
    }
}
