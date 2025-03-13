//
//  ViewManager.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

class ViewManager: NSObject, ObservableObject {
    @Published var currentView: ViewType
    @Published var userLocation: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    @Published var currentHealthModel: HealthModel?
    
    enum ViewType {
        case main
        case profile
        case health
        case healthModel(HealthModel)
        case healthResources
        case login
    }
    
    override init() {
            // Initialize stored properties before calling super.init()
                let initialView = Auth.auth().currentUser != nil ? ViewType.main : .login
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

