//
//  landmarkAnnotation.swift
//  integrateMap
//
//  Created by Vin Somasundaram on 4/13/20.
//  Copyright © 2020 Vin Somasundaram. All rights reserved.
//

import Foundation
import UIKit
import MapKit

final class landmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}

