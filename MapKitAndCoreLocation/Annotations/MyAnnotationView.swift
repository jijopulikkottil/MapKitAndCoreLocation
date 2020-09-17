//
//  MyAnnotation.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 13/09/20.
//  Copyright © 2020 mVoc. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotationView: MKMarkerAnnotationView {
    
    var location: String?
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "JIJO"
            if let anno = newValue as? MyAnnotation {
                location = anno.location?.locationName
                //glyphText = anno.displayName
                markerTintColor = UIColor.green
                canShowCallout = true
                let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
                rightCalloutAccessoryView = button
                displayPriority = .defaultHigh
            } 
        }
    }
}
