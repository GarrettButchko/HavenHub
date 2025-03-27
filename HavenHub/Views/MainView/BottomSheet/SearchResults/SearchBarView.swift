//
//  SearchBarView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import SwiftUI
import MapKit

struct SearchBarView: View {
    // Binding properties to communicate with the parent view
    @Binding var searchText: String // Tracks the text entered by the user
    @Binding var isKeyboardVisible: Bool // Indicates whether the keyboard is visible
    @Binding var showTitle: Bool // Controls the visibility of the title
    @Binding var offsetY: CGFloat // Tracks the vertical position of the bottom sheet
    @Binding var mapItems: [MapItemModel] // Stores the search results
    @Binding var keyboardHeight: CGFloat // Captures the height of the keyboard
    @Binding var region: MKCoordinateRegion? // Defines the map region for performing searches
    @FocusState.Binding var nameIsFocused: Bool // Tracks whether the text field is focused
    @Binding var searchTerms: [String]
    
    var body: some View {
        TextField("Search...", text: $searchText) // TextField for search input
            .padding(8) // Add padding inside the text field
            .background(.textFeild) // Background styling for the text field
            .cornerRadius(10) // Rounded corners for the text field
            .padding(.horizontal) // Horizontal padding around the text field
            
            // Trigger when the keyboard appears
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                
                withAnimation{
                    isKeyboardVisible = true
                }
                // Update the state to indicate the keyboard is visible
                offsetY = UIScreen.main.bounds.height * 0.08 // Adjust the bottom sheet's position
                
                // Hide the title with animation after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation {
                        showTitle = false
                    }
                }
            }
            .focused($nameIsFocused) // Bind the focus state to the text field
            
            // Trigger when the keyboard disappears
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                
                withAnimation {
                    isKeyboardVisible = false
                }
                 // Update the state to indicate the keyboard is hidden
                offsetY = UIScreen.main.bounds.height * (4/7) // Reset the bottom sheet's position
                
                // Show the title with animation after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation {
                        showTitle = true
                    }
                }
            }
            
            // Trigger whenever the search text changes
            .onChange(of: searchText) { _, newValue in
                if !newValue.isEmpty {
                    // Perform a search if the search text is not empty
                    let locationSearch = LocationSearch(mapItems: $mapItems)
                    locationSearch.performSearch(in: region!, word: newValue) // Pass the region for search
                }
            }
            
            // Bind the keyboard height to adjust UI elements if needed
            .keyboardHeight($keyboardHeight)
    }
}
