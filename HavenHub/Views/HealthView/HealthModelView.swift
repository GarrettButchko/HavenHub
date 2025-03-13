//
//  HealthModelView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 2/2/25.
//

import SwiftUI
import MapKit
import CoreLocation

enum Destination {
    case healthResources
}

struct HealthModelView: View {
    @StateObject var viewManager: ViewManager
    @Binding var showBottomSheet: Bool
    @Binding var showResources: Bool
    @Binding var resources: [MKMapItem]
    @State var healthModel: HealthModel
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            viewManager.navigateToHealth()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.blue)
                            Text("Back")
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                    Spacer()
                }
                
                ScrollView {
                    Text(healthModel.info.title)
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Image(healthModel.image) // Load image from Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                    
                    Text(healthModel.info.overview)
                        .padding()
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Text("Symptoms of " + healthModel.info.title)
                        .font(.headline)
                        .padding(10)
                    
                    if healthModel.type == "Mental Health", let symptoms = healthModel.info.symptoms, !symptoms.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(symptoms, id: \.self) { symptom in
                                Text(symptom)
                                    .padding(.leading, 10)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("No specific symptoms listed.")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                    
                    Text("Resources for managing " + healthModel.info.title)
                        .font(.headline)
                        .padding(10)
                    
                    Text("Let us help you get better - all one click away!")
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            // Perform search based on healthModel.info.title
                            if let visibleRegion = visibleRegion {
                                let queryWords = ["\(healthModel.info.title) resource", "\(healthModel.info.title) health service"]
                                performSearch(in: visibleRegion, queryWords: queryWords) { success in
                                    if success {
                                        // After search completes successfully, navigate to HealthResourcesView
                                        viewManager.navigateToHealthResources()
                                    } else {
                                        print("Search failed or returned no results.")
                                    }
                                }
                            } else {
                                print("Visible region is not set. Using default region.")
                                let defaultRegion = MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), // Default to Apple HQ
                                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                )
                                let queryWords = ["\(healthModel.info.title) resource", "\(healthModel.info.title) health service"]
                                performSearch(in: defaultRegion, queryWords: queryWords) { success in
                                    if success {
                                        viewManager.navigateToHealthResources()
                                    } else {
                                        print("Search with default region failed.")
                                    }
                                }
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    colors: [Color.mint, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "person.line.dotted.person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                Text("Resources")
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            .padding(8)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            // Set visibleRegion based on user's location if available
            if let userLocation = viewManager.userLocation {
                visibleRegion = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            } else {
                // Fallback to a default region if location is not available
                visibleRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), // Default to Apple HQ
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
        }
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
    
    func performSearch(in region: MKCoordinateRegion, queryWords: [String], completion: @escaping (Bool) -> Void) {
        resources.removeAll()
        var foundItems = false
        
        let dispatchGroup = DispatchGroup()
        
        for keyword in queryWords {
            dispatchGroup.enter()
            findLocations(region: region, searchReq: keyword) { mapItems in
                defer { dispatchGroup.leave() }
                if let mapItems = mapItems, !mapItems.isEmpty {
                    resources.append(contentsOf: mapItems)
                    foundItems = true
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(foundItems)
        }
    }
}


