//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewManager = ViewManager()
    
    var body: some View {
        VStack {
            switch viewManager.currentView {
            case .main:
                MainView(viewManager: viewManager)
                    .transition(.move(edge: .leading))
            case .profile:
                ProfileView(viewManager: viewManager)
                    .transition(.move(edge: .trailing))
            case .health:
                HealthView(viewManager: viewManager)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}
