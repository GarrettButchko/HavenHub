//
//  MainView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import MapKit

struct MainView: View {
    @StateObject var viewManager: ViewManager
    
    @State var offsetY: CGFloat = 540
    @State var showTitle: Bool = true
    @State private var isKeyboardVisible = false
    @State private var showingMenu = false
    @State var cameraPosition: MapCameraPosition = .automatic
    @State var visibleRegion: MKCoordinateRegion?
    @State private var mapItems: [MKMapItem] = []
    @State private var currentItem: MKMapItem?
    @State var showEmergency: Bool = false
    @State var route: MKRoute?
    @State var searchTerms: [String] = ["Homeless Shelters"]
    @State var showFoodBank: Bool = false
    @State var showBottomSheet: Bool = true
    @State var shelters: [MKMapItem] = []
    @State var selectedResult: MKMapItem?
    
    let userLocation = UserLocation()
    let routeCalc = RouteCalculator()
    let distanceCalc = DistanceCalculator()
    
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .top) {
                MainMapView(cameraPosition: $cameraPosition,
                            route: $route,
                            currentItem: $currentItem,
                            showingMenu: $showingMenu,
                            visibleRegion: $visibleRegion,
                            shelters: $shelters,
                            selectedResult: $selectedResult,
                            userLocation: userLocation,
                            distanceCalc: distanceCalc,
                            routeCalc: routeCalc
                )
                
                MapOverlayView(showTitle: $showTitle, route: $route, cameraPosition: $cameraPosition, locationSearch: userLocation, searchTerms: $searchTerms, routeCalc: routeCalc, userLocation: userLocation, viewManager: viewManager)
                    .shadow(radius: 5)
                
                if (showBottomSheet) {
                    BottomSheetView(
                        offsetY: $offsetY,
                        isKeyboardVisible: $isKeyboardVisible,
                        cameraPosition: $cameraPosition,
                        showEmergency: $showEmergency,
                        mapItems: $mapItems,
                        visibleRegion: $visibleRegion,
                        currentItem: $currentItem,
                        showTitle: $showTitle,
                        showingMenu: $showingMenu,
                        route: $route,
                        shelters: $shelters,
                        showBottomSheet: $showBottomSheet,
                        showFoodBank: $showFoodBank,
                        
                        userLocation: MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        ), searchTerms: $searchTerms, userLocationStruct: userLocation, distanceCalc: distanceCalc, routeCalc: routeCalc, viewManager: viewManager
                    )
                }
                
//                if (showFoodBank){
//                    
//                    FoodBankView(cameraPosition: $cameraPosition, visibleRegion: $visibleRegion, shelters: $shelters, showBottomSheet: $showBottomSheet, showFoodBank: $showFoodBank, showTitle: $showTitle)
//                    
//                }
//                
                EmergencyView(showEmergency: $showEmergency)
                    .opacity(showEmergency ? 1 : 0)
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    
    }
}
