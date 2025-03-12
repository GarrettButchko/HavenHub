//
//  HealthModel.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

struct HealthModel: Codable, Hashable {
    var type: String
    var icon: String
    var color: String
    var image: String
    var info: Info

}

struct Info: Codable, Hashable {
    var title: String
    var subtitle: String
    var overview: String
    var symptoms: [String]?
}
