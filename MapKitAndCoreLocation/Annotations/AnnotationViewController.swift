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

enum AnnotationType {
    case restaurant
}

struct MyLocation {
    var annotationType: AnnotationType
    var locationName: String
    var locationCoordinate: CLLocationCoordinate2D
}

class AnnotationViewController: UIViewController {
    
    //10.0443° N, 76.3282° E
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //mapView.mapType = .satellite
        mapView.delegate = self
        
        //registering our custom class as annotation view. So no need to explicitly create instance of MyAnnotationView
        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MyClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        let c1 = CLLocationCoordinate2D(latitude: 10.0243, longitude: 76.3282)
        let c2 = CLLocationCoordinate2D(latitude: 10.0343, longitude: 76.3382)
        let c3 = CLLocationCoordinate2D(latitude: 10.0443, longitude: 76.3282)
        
        
        let l1 = MyLocation(annotationType: .restaurant, locationName: "A1", locationCoordinate: c1)
        let l2 = MyLocation(annotationType: .restaurant, locationName: "A2", locationCoordinate: c2)
        let l3 = MyLocation(annotationType: .restaurant, locationName: "A3", locationCoordinate: c3)
        
        
        let arrayAnnotation = [l1, l2, l3].map { MyAnnotation($0) }
        mapView.addAnnotations(arrayAnnotation)
        
        let region = MKCoordinateRegion(center: c1, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        //mapView.showAnnotations(arrayAnnotation, animated: true)
    }
}

extension AnnotationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         if let myAnnotation = annotation as? MyAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            
            if annotationView == nil {
                annotationView = MyAnnotationView(annotation: myAnnotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            //set properties which are unique for each annotationview
            annotationView?.annotation = myAnnotation
            return annotationView
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            if annotationView == nil {
                annotationView = MyClusterAnnotationView(annotation: clusterAnnotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            }
            //set properties which are unique for each annotationview
            annotationView?.annotation = clusterAnnotation
            return annotationView
        } else {
            return nil
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotateView = view as? MyAnnotationView {
            print("location = \(String(describing: annotateView.location))")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotateView = view as? MyAnnotationView {
            print("location = \(String(describing: annotateView.location))")
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotateView = view as? MyAnnotationView {
            print("location = \(String(describing: annotateView.location))")
        }
    }
}
