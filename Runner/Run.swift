//
//  Run.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-17.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class Run: NSManagedObject {
    
    @NSManaged var coordinates:[CLLocation]
    @NSManaged var time: String
    @NSManaged var distance: Double
    @NSManaged var speed: Double
    @NSManaged var hours: Int
    @NSManaged var minutes: Int
    @NSManaged var seconds: Int
    @NSManaged var runName: String
    @NSManaged var satisfaction: String
}
