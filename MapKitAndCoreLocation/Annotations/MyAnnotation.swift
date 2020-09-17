//
//  Anntotion.swift
//  MapIntro
//
//  Created by Jijo Pulikkottil on 13/09/20.
//  Copyright © 2020 mVoc. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotation: MKPointAnnotation {
    
    var location: MyLocation?
    init(_ location: MyLocation) {
        super.init()
        self.location = location
        self.title = location.locationName
        self.coordinate = location.locationCoordinate
    }
}
