//
//  MKCoordinateRegion-Contains.swift
//  HavenHub
//
//  Created by Garrett Butchko on 3/1/25.
//

import MapKit

extension MKCoordinateRegion {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let latMin = center.latitude - (span.latitudeDelta / 2)
        let latMax = center.latitude + (span.latitudeDelta / 2)
        let lonMin = center.longitude - (span.longitudeDelta / 2)
        let lonMax = center.longitude + (span.longitudeDelta / 2)
        
        return (latMin...latMax).contains(coordinate.latitude) &&
               (lonMin...lonMax).contains(coordinate.longitude)
    }
}
