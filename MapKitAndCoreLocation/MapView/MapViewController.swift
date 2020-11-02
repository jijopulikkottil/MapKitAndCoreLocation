//
//  ViewController.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 03/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//
import UIKit
import MapKit
////https://developer.apple.com/documentation/mapkit

class MapViewController: UIViewController {

    //10.0443° N, 76.3282° E
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.mapType = .satellite
        
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        let coordinate = CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3282)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)

    }
}
