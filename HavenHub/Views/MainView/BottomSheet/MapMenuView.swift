//
//  MapMenuView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

public struct MapMenuView: View {
    
    @Binding var mapItem: MapItemModel?
    @Binding var showingMenu: Bool
    @State var scene: MKLookAroundScene?
    
    public var body: some View {
        VStack{
            HStack{
                Text(mapItem?.mapItem.name ?? "No Name")
                    .font(.headline)
            
                Spacer()
                
                Button {
                    withAnimation{
                        showingMenu = false
                    }
                } label: {
                    Text("Cancel")
                        .frame(width: 70, height: 30)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
            
            Button(action: {
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking] // Set driving mode

                MKMapItem.openMaps(with: [mapItem!.mapItem], launchOptions: launchOptions)
            }) {
                ZStack {
                    // Background style
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                    
                    // Icon and label
                    VStack {
                        Image(systemName: "arrow.turn.up.right")
                            .foregroundColor(.main)
                        Text("Directions")
                            .foregroundStyle(.main)
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(height: 60)
        }
        .padding([.horizontal, .bottom])
    }
}
