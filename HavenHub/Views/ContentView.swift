//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var viewManager = ViewManager()
    @StateObject var authViewModel = AuthViewModel()
    
    @State private var showBottomSheet: Bool = false
    @State private var showResources: Bool = false
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var resources: [MKMapItem] = []
    
    var body: some View {
        VStack {
            switch viewManager.currentView {
            case .main:
                MainView(viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
            case .profile:
                ProfileView(viewManager: viewManager, authViewModel: authViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .health:
                HealthView(viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .healthModel(let healthModel):
                HealthModelView(viewManager: viewManager,
                                showBottomSheet: $showBottomSheet,
                                showResources: $showResources,
                                resources: $resources,
                                healthModel: healthModel)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .healthResources:
                            HealthResourcesView(
                                cameraPosition: $cameraPosition,
                                visibleRegion: $visibleRegion,
                                resources: $resources,
                                showBottomSheet: $showBottomSheet,
                                showResources: $showResources,
                                showTitle: .constant(false),
                                viewManager: viewManager
                            )
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .login:
                LoginView(authViewModel: authViewModel, viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .food:
                FoodBankView(viewManager: viewManager)
//                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }
    }
}
