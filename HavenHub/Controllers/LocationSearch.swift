//
//  LocationSearch.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/15/25.
//
import MapKit
import SwiftUI
import Contacts

struct LocationSearch {
    
    @Binding var mapItems: [MapItemModel]
    var authViewModel = AuthViewModel()
    
    
    
    func findLocationsOld(region: MKCoordinateRegion, searchReq: String, completion: @escaping ([MKMapItem]?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchReq
        searchRequest.region = region

        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let error = error {
                print("Error during search: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response else {
                print("No response received.")
                completion(nil)
                return
            }
            
            completion(response.mapItems)
        }
    }
    

    func findLocationsNew(region: MKCoordinateRegion, searchReq: String, completion: @escaping ([MapItemModel]?) -> Void) {
            
        var mapItems: [MapItemModel] = []
        
        authViewModel.fetchGlobalShelters() { shelters in
            if let newShelters = shelters {
                for shelter in newShelters {
                    let coordinate = CLLocationCoordinate2D(latitude: shelter.location.latitude, longitude: shelter.location.longitude)
                    
                    // Check if the coordinate is inside the region
                    if region.contains(coordinate) && shelter.verified && shelter.name.lowercased().contains(searchReq.lowercased()) {
                        
                        // Create a placemark with the address dictionary
                        let addressDict: [String: Any] = [
                            CNPostalAddressStreetKey: shelter.location.address,
                            CNPostalAddressCityKey: shelter.location.city,
                            CNPostalAddressStateKey: shelter.location.state,
                            CNPostalAddressPostalCodeKey: shelter.location.zip
                        ]
                        
                        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = shelter.name // Assign shelter name
                        let mapItemModel = MapItemModel(shelter: shelter, mapItem: mapItem)
                        mapItems.append(mapItemModel)
                    }
                }
            }
            completion(mapItems)
        }
    }


    
    func performSearch(in region: MKCoordinateRegion, word: String) {
        
        self.mapItems.removeAll()
        
        findLocationsNew(region: region, searchReq: word) { mapItems1 in
            if let mapItems1 = mapItems1, !mapItems1.isEmpty {
                self.mapItems.append(contentsOf: mapItems1)
            }
        }
    }
}

