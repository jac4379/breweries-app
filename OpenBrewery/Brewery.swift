//
//  Brewery.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//

import Foundation

struct Brewery: Codable, Identifiable {
    let id: String
    let name: String
    let breweryType: String
    let street: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let phone: String?
    let websiteUrl: String?
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case breweryType = "brewery_type" // Map JSON key
            case street
            case city
            case state
            case postalCode = "postal_code" // Map JSON key
            case phone
            case websiteUrl = "website_url" // Map JSON key
        }
}
