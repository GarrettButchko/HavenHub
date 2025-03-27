//
//  TitleBarView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI
import MapKit

struct MapOverlayView: View {
    @Binding var showTitle: Bool
    @Binding var route: MKRoute?
    @Binding var cameraPosition: MapCameraPosition
    let locationSearch: UserLocation
    @State var but1: Bool = true
    @State var but2: Bool = false
    @State var but3: Bool = false
    @State var but4: Bool = false
    @Binding var searchTerms : [String]
    @Binding var showSheet: Bool
    
    let routeCalc: RouteCalculator
    let userLocation: UserLocation
    @StateObject var viewManager: ViewManager
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack {
                    Text("HavenHub")
                        .frame(width: 160, height: 40)
                        .font(.title)
                        .foregroundColor(.primary)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    LocationButton(route: $route, cameraPosition: $cameraPosition, locationSearch: UserLocation())
                    
                    ProfileButton(viewManager: viewManager, showSheet: $showSheet)
                }
                
                Spacer()
                
                HStack{
                    Spacer()
                    
                    CategoryButtonView(icon: "house.fill", color: .yellow, on: $but1) {
                        if !but2 && !but3 && !but4 {
                            but1 = true
                        }
                        searchTerms.removeAll()
                        
                        if but1{
                            searchTerms.append(contentsOf: ["Homeless Shelters"])
                        }
                        if but2{
                            searchTerms.append(contentsOf: ["Food Banks"])
                        }
                        if but3{
                            searchTerms.append(contentsOf: ["Medical Services"])
                        }
                        if but4{
                            searchTerms.append(contentsOf: ["Homeless Closets"])
                        }
                        
                        print(searchTerms)
                    }
                    CategoryButtonView(icon: "fork.knife", color: .brown, on: $but2) {
                        
                        if !but2 && !but3 && !but4 {
                            but1 = true
                        }
                        
                        searchTerms.removeAll()
                        
                        if but1{
                            searchTerms.append(contentsOf: ["Homeless Shelters"])
                        }
                        if but2{
                            searchTerms.append(contentsOf: ["Soup Kitchens"])
                        }
                        if but3{
                            searchTerms.append(contentsOf: ["Medical Services"])
                        }
                        if but4{
                            searchTerms.append(contentsOf: ["Homeless Closets"])
                        }
                        
                        print(searchTerms)
                    }
                    CategoryButtonView(icon: "cross.fill", color: .red, on: $but3) {
                        
                        if !but2 && !but3 && !but4 {
                            but1 = true
                        }
                        
                        searchTerms.removeAll()
                        
                        if but1{
                            searchTerms.append(contentsOf: ["Homeless Shelters"])
                        }
                        if but2{
                            searchTerms.append(contentsOf: ["Soup Kitchens"])
                        }
                        if but3{
                            searchTerms.append(contentsOf: ["Medical Services"])
                        }
                        if but4{
                            searchTerms.append(contentsOf: ["Homeless Closets"])
                        }
                        
                        print(searchTerms)
                    }
                    CategoryButtonView(icon: "hanger", color: .purple, on: $but4) {
                        
                        if !but2 && !but3 && !but4 {
                            but1 = true
                        }
                        
                        searchTerms.removeAll()
                        
                        if but1{
                            searchTerms.append(contentsOf: ["Homeless Shelters"])
                        }
                        if but2{
                            searchTerms.append(contentsOf: ["Soup Kitchens"])
                        }
                        if but3{
                            searchTerms.append(contentsOf: ["Medical Services"])
                        }
                        if but4{
                            searchTerms.append(contentsOf: ["Homeless Closets"])
                        }
                        
                        print(searchTerms)
                    }
                }
            }
            .padding(.horizontal)
            .opacity(showTitle ? 1 : 0)
            .frame(height: geometry.size.height * (3 / 6) - 20)
            .onTapGesture {
                if !but2 && !but3 && !but4 {
                    but1 = true
                }
            }
        }
    }
}
