//
//  landmark.swift
//  integrateMap
//
//  Created by Vin Somasundaram on 4/13/20.
//  Copyright © 2020 Vin Somasundaram. All rights reserved.
//

import Foundation
import MapKit

struct Landmark {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
    
    
}

