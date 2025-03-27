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
    @StateObject var authViewModel: AuthViewModel
    
    @State var offsetY: CGFloat = 540
    @State var showTitle: Bool = true
    @State private var isKeyboardVisible = false
    @State private var showingMenu = false
    @State var cameraPosition: MapCameraPosition = .automatic
    @State var visibleRegion: MKCoordinateRegion?
    @State private var mapItems: [MapItemModel] = []
    @State private var currentItem: MapItemModel?
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
        ZStack(alignment: .top) {
            MainMapView(cameraPosition: $cameraPosition,
                        route: $route,
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
                        visibleRegion: $visibleRegion, userLocation: userLocation, distanceCalc: distanceCalc, routeCalc: routeCalc)

            MapOverlayView(showTitle: $showTitle, route: $route, cameraPosition: $cameraPosition, locationSearch: userLocation, searchTerms: $searchTerms, showSheet: $isSheetPresented, routeCalc: routeCalc, userLocation: userLocation, viewManager: viewManager)
                .shadow(radius: 5)

            BottomSheetView(
                offsetY: $offsetY,
                isKeyboardVisible: $isKeyboardVisible,
                cameraPosition: $cameraPosition,
                showEmergency: $showEmergency,
                mapItems: $mapItems,
                region: $visibleRegion,
                currentItem: $currentItem,
                showTitle: $showTitle,
                showingMenu: $showingMenu,
                route: $route,
                userLocation: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ), searchTerms: $searchTerms, userLocationStruct: userLocation, distanceCalc: distanceCalc, routeCalc: routeCalc, viewManager: viewManager
            )

            EmergencyView(showEmergency: $showEmergency)
                .opacity(showEmergency ? 1 : 0)
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $isSheetPresented) {
            ProfileView(viewManager: viewManager, authViewModel: authViewModel)
        }
    }
}
