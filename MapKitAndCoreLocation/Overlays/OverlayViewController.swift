//
//  OverlayViewController.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 09/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

import UIKit
import MapKit
//https://developer.apple.com/documentation/mapkit/mapkit_overlays

class OverlayViewController: UIViewController {

    //10.0443° N, 76.3282° E
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Map delegate
        mapView.delegate = self
        
        //Add Annotation - MKPointAnnotation
        let annotation = MKPointAnnotation()
        annotation.title = "CUSAT"
        annotation.subtitle = "The M Voc"

        annotation.coordinate = CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3282)
        mapView.addAnnotation(annotation)

        //Circle overlay - MKCircle
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3282), radius: 400)
        mapView.addOverlay(circle)
        //mapView.setVisibleMapRect(circle.boundingMapRect, animated: true)
        
        
        let c1 = CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3282)
        let c2 = CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3382)
        let c3 = CLLocationCoordinate2D(latitude: 10.0543, longitude: 76.3282)
        let polyline = MKPolygon(coordinates: [c1, c2, c3], count: 3)
        mapView.addOverlay(polyline)
        
        //let region = MKCoordinateRegion(polyline.boundingMapRect)
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
}

// MARK: MKMapViewDelegate
extension OverlayViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if overlay is MKCircle {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.lineWidth = 1
        circleView.strokeColor = UIColor.red
        circleView.fillColor = UIColor.red.withAlphaComponent(0.3)
        return circleView
        
      } else if overlay is MKPolygon {
        let circleView = MKPolygonRenderer(overlay: overlay)
        circleView.lineWidth = 1
        circleView.strokeColor = UIColor.green
        circleView.fillColor = UIColor.green.withAlphaComponent(0.3)
        return circleView
      }
      return MKOverlayRenderer()
    }
}
