//
//  MainMapView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI
import MapKit

struct MainMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var route: MKRoute?
    @Binding var currentItem: MapItemModel?
    @Binding var showingMenu: Bool
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var shelters: [MKMapItem]
    @Binding var selectedResult: MKMapItem?
    
    let userLocation: UserLocation
    let distanceCalc: DistanceCalculator
    let routeCalc: RouteCalculator
    
    var body: some View {
        GeometryReader { geometry in
            
            Map(position: $cameraPosition, selection: $selectedResult) {
                ForEach(shelters, id: \.self) { shelter in
                    Marker(shelter.name ?? "Unknown", coordinate: shelter.placemark.coordinate)
                        .tint(Color.blue)
                }
                
                if let currentItem = currentItem {
                    Annotation("", coordinate: currentItem.mapItem.placemark.coordinate) {
                        MapItemBubble(mapItem: currentItem)
                    }
                }

                UserAnnotation()

                if let route = route {
                    MapPolyline(route)
                        .stroke(
                            Color.blue,
                            style: StrokeStyle(
                                lineWidth: 7,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )

                    if let centerCoordinate = routeCalc.getCenterCoordinate(from: route) {
                        Annotation("", coordinate: centerCoordinate) {
                        
                            TravelTimeBubble(from: userLocation.getUserLocation().center, to: currentItem!.mapItem.placemark.coordinate, distanceCalc: distanceCalc)
                            
                        }
                    }
                }
            }
            .onAppear {
                userLocation.goToUserLocation(cameraPosition: $cameraPosition)
            }
            .onChange(of: route) { _, newValue in
                if let newRoute = newValue {
                    withAnimation {
                        cameraPosition = routeCalc.adjustCameraForRoute(newRoute)
                    }
                }
            }
            .onChange(of: showingMenu) { _, newValue in
                if !newValue {
                    route = nil
                    currentItem = nil
                    withAnimation {
                        userLocation.goToUserLocation(cameraPosition: $cameraPosition)
                    }
                }
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .mapControls {
                MapCompass()
                    .mapControlVisibility(.hidden)
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.495)
            .ignoresSafeArea(.keyboard)
            .safeAreaPadding(.bottom, 50)
        }
    }
}


struct TravelTimeBubble: View {
    let from: CLLocationCoordinate2D
    let to: CLLocationCoordinate2D
    let distanceCalc: DistanceCalculator
    
    var body: some View {
        let travelTime = distanceCalc.estimatedTravelTime(from: from, to: to)
        
        SpeechBubble(rectangleWidth: CGFloat((travelTime.count + 1) * 10), rectangleHeight: 20)
            .stroke(Color.teal, lineWidth: 5)
            .fill(.blue)
            .frame(width: 150, height: 30)
            .offset(x: 0, y: -20)
            .shadow(radius: 5)
            .overlay {
                Text(travelTime)
                    .offset(x: 0, y: -25)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
            }
    }
    
    
}

struct MapItemBubble: View {
    var mapItem: MapItemModel
    var rectangleHeight: CGFloat = 50
    
    var body: some View {
        if mapItem.shelter.info.subType == "Shelter"{
            SpeechBubble(rectangleWidth: CGFloat((mapItem.shelter.name.count + 1) * 10) + 30, rectangleHeight: rectangleHeight)
                .fill(.secondary)
                .frame(width: 150, height: rectangleHeight + 10)
                .offset(x: 0, y: -20)
                .shadow(radius: 5)
                .overlay {
                    VStack{
                        HStack{
                            Image(systemName: getImage(mapItem: mapItem))
                                .foregroundStyle(.white)
                            Text(mapItem.shelter.name)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        ProgressView(value: Float(Double(mapItem.shelter.info.capacity + 1) / 5.0))
                            .frame(width: CGFloat((mapItem.shelter.name.count + 1) * 10))
                            
                    }
                    .offset(x: 0, y: -25)
                }
        } else {
            SpeechBubble(rectangleWidth: CGFloat((mapItem.shelter.name.count + 1) * 10), rectangleHeight: 20)
                .fill(.secondary)
                .frame(width: 150, height: 30)
                .offset(x: 0, y: -20)
                .shadow(radius: 5)
                .overlay {
                    VStack{
                        HStack{
                            Image(systemName: getImage(mapItem: mapItem))
                            Text(mapItem.shelter.name)
                                .offset(x: 0, y: -35)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    }
                }
        }
    }
    
    func getImage(mapItem: MapItemModel) -> String {
            let systemName: String
            switch mapItem.shelter.info.subType {
            case "Shelter":
                systemName = "house.fill"
            case "Food Bank":
                systemName = "fork.knife"
            case "Clinic/Health Center":
                systemName = "cross.fill"
            case "Clothing Center":
                systemName = "hanger"
            default:
                systemName = "house.fill"
            }
        return systemName
        }
    
    
}
