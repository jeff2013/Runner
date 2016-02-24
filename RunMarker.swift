//
//  RunMarker.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-24.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import MapKit

class RunMarker: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let identifier: String
    
    init(identifier: String, coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
