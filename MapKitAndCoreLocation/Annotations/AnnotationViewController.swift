//
//  AnnotationViewController.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 09/09/20.
//  Copyright © 2020 mVoc. All rights reserved.
//
//https://developer.apple.com/documentation/mapkit/mkannotationview/decluttering_a_map_with_mapkit_annotation_clustering
import UIKit
import MapKit

struct MyLocation {
    var locationName: String
    var locationCoordinate: CLLocationCoordinate2D
}

class AnnotationViewController: UIViewController {
    
    //10.0443° N, 76.3282° E
    let annotationViewItentifier = "MyAnnotationView"
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //mapView.mapType = .satellite
        mapView.delegate = self
        
        //registering our custom class as annotation view. So no need to explicitly create instance of MyAnnotationView
//        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(MyClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        let c1 = CLLocationCoordinate2D(latitude: 10.0243, longitude: 76.3282)
        let c2 = CLLocationCoordinate2D(latitude: 10.0343, longitude: 76.3382)
        let c3 = CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3282)
        
        
        let l1 = MyLocation(locationName: "A1", locationCoordinate: c1)
        let l2 = MyLocation(locationName: "A2", locationCoordinate: c2)
        let l3 = MyLocation(locationName: "A3", locationCoordinate: c3)
        
        
        let arrayAnnotation = [l1, l2, l3].map { MyAnnotation($0) }
        mapView.addAnnotations(arrayAnnotation)
        
        mapView.showAnnotations(arrayAnnotation, animated: true)
        
        //        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        //        mapView.setRegion(MKCoordinateRegion(center: c1, span: span), animated: true)
        //
    }
}

extension AnnotationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         if let myAnnotation = annotation as? MyAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewItentifier)
            if annotationView == nil {
                annotationView = MyAnnotationView(annotation: myAnnotation, reuseIdentifier: annotationViewItentifier)
            }
            return annotationView
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MyClusterAnnotationView")
            if annotationView == nil {
                annotationView = MyClusterAnnotationView(annotation: clusterAnnotation, reuseIdentifier: "MyClusterAnnotationView")
            }
            return annotationView
        } else {
            return nil
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotateView = view as? MyAnnotationView {
            print("location = \(annotateView.location)")
        }
    }
}
