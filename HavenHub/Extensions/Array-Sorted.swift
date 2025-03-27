//
//  Array-Sorted.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import MapKit

// MARK: - Sorting Extension
extension Array where Element == MapItemModel {
    func sortedBySearchText(_ searchText: String) -> [MapItemModel] {
        let lowerSearchText = searchText.lowercased()
        return self.sorted { a, b in
            let aValue = a.mapItem.name?.lowercased() ?? ""
            let bValue = b.mapItem.name?.lowercased() ?? ""
            
            // Exact matches first
            if aValue == lowerSearchText { return true }
            if bValue == lowerSearchText { return false }
            
            // Starts with the search text
            let aStartsWith = aValue.hasPrefix(lowerSearchText)
            let bStartsWith = bValue.hasPrefix(lowerSearchText)
            if aStartsWith && !bStartsWith { return true }
            if !aStartsWith && bStartsWith { return false }
            
            // Contains the search text
            let aContains = aValue.contains(lowerSearchText)
            let bContains = bValue.contains(lowerSearchText)
            if aContains && !bContains { return true }
            if !aContains && bContains { return false }
            
            return false
        }
    }
}
