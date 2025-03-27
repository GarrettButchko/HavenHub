//
//  ShelterModel.swift
//  HavenHub
//
//  Created by Garrett Butchko on 3/1/25.
//

import Foundation

struct UserModel: Codable, Hashable {
    var name: String
    var email: String
    var password: String
    var userType: UserType = .user
}

struct ShelterModel: Codable, Hashable {
    var id: String
    var name: String
    var contact: Contact
    var location: Location
    var info: ShelterInfo
    var verified: Bool
    var password: String
    var userType: UserType = .shelter
}

struct ShelterInfo: Codable, Hashable {
    var subtitle: String
    var description: String
    var capacity: Double
    var subType: String
}

struct Contact: Codable, Hashable {
    var phone: String
    var email: String
}

struct Location: Codable, Hashable {
    var address: String
    var city: String
    var state: String
    var zip: String
    var latitude: Double
    var longitude: Double
}

enum UserType: String, Codable {
    case shelter
    case user
}
