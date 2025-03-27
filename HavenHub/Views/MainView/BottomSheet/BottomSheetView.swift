import SwiftUI
import MapKit

struct BottomSheetView: View {
    @Binding var offsetY: CGFloat
    @Binding var isKeyboardVisible: Bool
    @Binding var cameraPosition: MapCameraPosition
    @Binding var showEmergency: Bool
    @Binding var mapItems: [MapItemModel]
    @Binding var region: MKCoordinateRegion?
    @Binding var currentItem: MapItemModel?
    @Binding var showTitle: Bool
    @Binding var showingMenu: Bool
    @Binding var route: MKRoute?
    @Binding var shelters: [MKMapItem]
    @Binding var showBottomSheet: Bool
    @Binding var showFoodBank: Bool
    @State var lastDragPosition: CGFloat = 0
    @State private var searchText: String = ""
    @State var userLocation: MKCoordinateRegion
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var nameIsFocused: Bool
    @Binding var searchTerms: [String]
    
    let userLocationStruct: UserLocation
    let distanceCalc: DistanceCalculator
    let routeCalc: RouteCalculator
    @StateObject var viewManager: ViewManager

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Capsule()
                        .frame(width: 38, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    SearchBarView(searchText: $searchText, isKeyboardVisible: $isKeyboardVisible, showTitle: $showTitle, offsetY: $offsetY, mapItems: $mapItems, keyboardHeight: $keyboardHeight, region: $region, nameIsFocused: $nameIsFocused, searchTerms: $searchTerms)

                    Group {
                        if isKeyboardVisible {
                            SearchResultsView(
                                searchText: $searchText,
                                mapItems: $mapItems,
                                currentItem: $currentItem,
                                keyboardHeight: $keyboardHeight,
                                nameIsFocused: $nameIsFocused,
                                route: $route,
                                showingMenu: $showingMenu, distanceCalc: distanceCalc, userLocation: userLocationStruct, routeCalc: routeCalc
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else if showingMenu {
                            MapMenuView(mapItem: $currentItem, showingMenu: $showingMenu)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            ButtonView(showEmergency: $showEmergency, geometry: geometry, cameraPosition: $cameraPosition, viewManager: ViewManager(), shelters: $shelters, visibleRegion: $visibleRegion, showBottomSheet: $showBottomSheet, showFoodBank: $showFoodBank)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: isKeyboardVisible)

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height + 100)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
                .offset(y: min(max(offsetY, geometry.size.height * 0.08), geometry.size.height * (4 / 7)))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = lastDragPosition + value.translation.height
                            if !isKeyboardVisible {
                                offsetY = min(max(newOffset, geometry.size.height * 0.08), geometry.size.height * (4 / 7))
                            }
                        }
                        .onEnded { _ in
                            let screenHeight = geometry.size.height
                            offsetY = offsetY < screenHeight * 0.4
                                ? screenHeight * 0.08
                                : screenHeight * (4 / 7)
                            withAnimation() {
                                showTitle = offsetY >= screenHeight * 0.4
                            }
                            
                            lastDragPosition = offsetY
                        }
                )
                .animation(.easeInOut, value: offsetY)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                offsetY = geometry.size.height * (4 / 7)
                userLocation = userLocationStruct.getUserLocation()
            }
        }
    }
}
