//
//  SearchResultsView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

struct SearchResultsView: View {
    @Binding var searchText: String
    @Binding var mapItems: [MapItemModel]
    @Binding var currentItem: MapItemModel?
    @Binding var keyboardHeight: CGFloat
    @FocusState.Binding var nameIsFocused: Bool
    @Binding var route: MKRoute?
    @Binding var showingMenu: Bool
    
    let distanceCalc: DistanceCalculator
    let userLocation: UserLocation
    let routeCalc: RouteCalculator
    
    var body: some View {
        GeometryReader { geometry in
            SearchResultsListView(
                searchText: searchText,
                sortedItems: mapItems.sortedBySearchText(searchText),
                currentItem: $currentItem,
                nameIsFocused: $nameIsFocused, route: $route, showingMenu: $showingMenu,
                distanceCalc: distanceCalc,
                userLocation: userLocation, routeCalc: routeCalc
            )
            .frame(width: geometry.size.width, height: geometry.size.height - keyboardHeight - 60)
        }
    }
}

// MARK: - Search Results List
struct SearchResultsListView: View {
    let searchText: String
    let sortedItems: [MapItemModel]
    @Binding var currentItem: MapItemModel?
    @FocusState.Binding var nameIsFocused: Bool
    @Binding var route: MKRoute?
    @Binding var showingMenu: Bool
    
    let distanceCalc: DistanceCalculator
    let userLocation: UserLocation
    let routeCalc: RouteCalculator

    var body: some View {
        List {
            if searchText.isEmpty {
                EmptyStateView()
                    .listRowBackground(Color.clear)
            } else {
                ForEach(sortedItems, id: \.self) { item in
                    Button(action: {
                        currentItem = item
                        nameIsFocused = false
                        withAnimation {
                            showingMenu = true
                        }
                        routeCalc.calculateRoute(from: userLocation.getUserLocation().center, to: item.mapItem.placemark.coordinate) { route in
                            if let route = route {
                                print("Route distance: \(route.distance) meters")
                                self.route = route
                            } else {
                                print("Failed to get route")
                            }
                        }
                    }) {
                        SearchResultRow(
                            item: item.mapItem,
                            distanceCalc: distanceCalc,
                            userLocation: userLocation
                        )
                    }
                    .listRowBackground(Color.clear) // Removes the row background color
                }
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        
    }
}

// MARK: - Single Search Result Row
struct SearchResultRow: View {
    let item: MKMapItem
    let distanceCalc: DistanceCalculator
    let userLocation: UserLocation
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "Unknown Place")
                .font(.headline)

            Text("\(distanceCalc.distanceInMiles(coordinate1: item.placemark.coordinate, coordinate2: userLocation.getUserLocation().center)) mi - " + getPostalAddress(from: item))
                .font(.subheadline)
        }
    }
    
    func getPostalAddress(from mapItem: MKMapItem) -> String {
        let placemark = mapItem.placemark
        
        // Use MKPlacemark properties to construct an address
        var addressComponents: [String] = []
        
        if let subThoroughfare = placemark.subThoroughfare { addressComponents.append(subThoroughfare) }
        if let thoroughfare = placemark.thoroughfare { addressComponents.append(thoroughfare) }
        if let locality = placemark.locality { addressComponents.append(locality) }
        if let administrativeArea = placemark.administrativeArea { addressComponents.append(administrativeArea) }

        return addressComponents.joined(separator: ", ")
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Type Your Favorite Spot!")
            Spacer()
        }
    }
}


