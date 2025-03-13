//
//  HealthResourcesView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 3/3/25.
//

import SwiftUI
import MapKit

struct HealthResourcesView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var resources: [MKMapItem]
    @Binding var showBottomSheet: Bool
    @Binding var showResources: Bool
    @Binding var showTitle: Bool
    @State private var isKeyboardVisible: Bool = false
    @State var offsetY: CGFloat = 540
    @State var lastDragPosition: CGFloat = 0
    @ObservedObject var viewManager: ViewManager

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Back button to navigate to HealthModelView
                HStack {
                    Button(action: {
                        withAnimation {
                            if let healthModel = viewManager.currentHealthModel {
                                viewManager.navigateToHealthModel(healthModel: healthModel)
                            } else {
                                // Fallback to health view if no healthModel is available
                                viewManager.navigateToHealth()
                            }
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

                // Map view at the top
                Map(position: $cameraPosition) {
                    ForEach(resources, id: \.self) { resource in
                        Marker(resource.name ?? "Unknown", coordinate: resource.placemark.coordinate)
                    }
                }
                .frame(height: geometry.size.height * 0.6) // 60% of screen for map
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()

                // Bottom sheet with list
                VStack(spacing: 0) {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)

                    List(resources, id: \.self) { resource in
                        NavigationLink(destination: HealthResourcesDetailView(resource: resource)) {
                            VStack(alignment: .leading) {
                                Text(resource.name ?? "Unnamed Resource")
                                    .font(.headline)
                                Text(resource.placemark.title ?? "Address unavailable")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: geometry.size.height * 0.3) // 30% of screen for list

                    Button(action: {
                        withAnimation {
                            showResources = false
                            showBottomSheet = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 70, height: 70)
                            Text("X")
                                .font(.system(size: 25))
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
            }
        }
    }
}


