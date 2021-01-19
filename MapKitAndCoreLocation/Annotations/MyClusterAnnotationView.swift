//
//  MyClusterAnnotationView.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 15/09/20.
//  Copyright © 2020 mVoc. All rights reserved.
//

import Foundation
import MapKit

class MyClusterAnnotationView: MKMarkerAnnotationView {
    
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                glyphText = "\(cluster.memberAnnotations.count)"
            }
            
        }
    }
}
