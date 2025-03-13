//
//  ViewManager.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import MapKit

class ViewManager: NSObject, ObservableObject {
    @Published var currentView: ViewType
    @Published var userLocation: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    @Published var currentHealthModel: HealthModel?
    @Published var shelters: [MKMapItem] = []
    
    enum ViewType {
        case main
        case profile
        case health
        case healthModel(HealthModel)
        case healthResources
        case login
        case food
    }
    
    override init() {
            // Initialize stored properties before calling super.init()
                let initialView = Auth.auth().currentUser != nil ? ViewType.health : .login
                self.currentView = initialView
                self.currentHealthModel = nil
                super.init()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
        }
    
    // Simplified navigation methods using a single method with a parameter
    func navigateToMain() {
        currentView = .main
        currentHealthModel = nil
    }
        
    func navigateToProfile() {
        currentView = .profile
        currentHealthModel = nil
    }
    
    func navigateToHealth() {
        currentView = .health
        currentHealthModel = nil
    }
    
    func navigateToLogin() {
        currentView = .login
        currentHealthModel = nil
    }
    
    // Add navigation methods for the new cases
    func navigateToHealthModel(healthModel: HealthModel) {
        currentView = .healthModel(healthModel)
        currentHealthModel = healthModel
    }
    
    func navigateToHealthResources() {
        currentView = .healthResources
    }
        
    func navigateToFood(visibleRegion: MKCoordinateRegion?) {
        print("Navigating to food...") // Debugging line
        let queryWords = ["food banks"]

        // Use visibleRegion if available, otherwise set a default region (Columbus, OH)
        let searchRegion = visibleRegion ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), // Columbus, OH
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        print("Search region: \(searchRegion)") // Debugging line

        // Perform the search
        performSearch(in: searchRegion, queryWords: queryWords)

        // Change currentView to trigger the navigation to FoodBankView
        DispatchQueue.main.async {
            self.currentView = .food
        }
        
        print("currentView set to .food") // Debugging line
    }
    
    func findLocations(region: MKCoordinateRegion, searchReq: String, completion: @escaping ([MKMapItem]?) -> Void) {
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

    func performSearch(in region: MKCoordinateRegion, queryWords: [String]) {
        DispatchQueue.main.async {
            self.shelters.removeAll()
        }
        
        for keyword in queryWords {
            findLocations(region: region, searchReq: keyword) { mapItems in
                if let mapItems = mapItems, !mapItems.isEmpty {
                    DispatchQueue.main.async {
                        self.shelters.append(contentsOf: mapItems)
                    }
                }
            }
        }
    }
}

extension ViewManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

