//
//  HealthResourcesDetailView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 3/3/25.
//

import SwiftUI
import MapKit

struct HealthResourcesDetailView: View {
    let resource: MKMapItem
    @State private var cameraPosition: MapCameraPosition
    @State private var showMapOptions = false
    @State private var description: String = "No description available"

    init(resource: MKMapItem) {
        self.resource = resource
        let coordinate = resource.placemark.coordinate
        _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }

    var body: some View {
        VStack {
            Text(resource.name ?? "Unnamed Resource")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Map(position: $cameraPosition) {
                Marker(resource.name ?? "Unknown", coordinate: resource.placemark.coordinate)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Phone number
                    if let phoneNumber = resource.phoneNumber {
                        Button(action: {
                            if let phoneURL = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
                                UIApplication.shared.open(phoneURL)
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                    .frame(height: 50)
                                Text("Call \(phoneNumber)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    } else {
                        Text("Phone number unavailable")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Email (corrected logic)
                    if let urlString = resource.url?.absoluteString,
                       urlString.contains("mailto:"),
                       let email = urlString.split(separator: ":").last.map(String.init), !email.isEmpty {
                        Button(action: {
                            if let emailURL = URL(string: "mailto:\(email)") {
                                UIApplication.shared.open(emailURL)
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                    .frame(height: 50)
                                Text("Email \(email)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .truncationMode(.tail)
                                    .padding(.horizontal, 10)
                            }
                        }
                    } else {
                        Text("Email unavailable")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Website
                    if let url = resource.url, !url.absoluteString.contains("mailto:") {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                    .frame(height: 50)
                                Text(url.absoluteString)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .truncationMode(.tail)
                                    .padding(.horizontal, 10)
                            }
                        }
                    } else {
                        Text("Website unavailable")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Address
                    if let address = resource.placemark.title {
                        Button(action: {
                            showMapOptions = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                    .frame(height: 50)
                                Text(address)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .truncationMode(.tail)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .confirmationDialog("Open in ...", isPresented: $showMapOptions, titleVisibility: .visible) {
                            Button("Open in Apple Maps") {
                                if let resourceName = resource.name, let address = resource.placemark.title {
                                    let query = "\(resourceName), \(address)"
                                    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                    let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(encodedQuery)")!
                                    UIApplication.shared.open(appleMapsURL)
                                }
                            }
                            Button("Open in Google Maps") {
                                if let resourceName = resource.name, let address = resource.placemark.title {
                                    let query = "\(resourceName), \(address)"
                                    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                    let googleMapsURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)")!
                                    UIApplication.shared.open(googleMapsURL)
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    } else {
                        Text("Address unavailable")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Description
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 10)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Resource Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Example: Fetch description (implement based on your data source)
            // description = fetchDescription(for: resource)
            // For now, we can simulate a description based on available data
            if let name = resource.name {
                description = "This is a resource for \(name). For more information, please contact them via the provided phone number or website."
            }
        }
    }
}

