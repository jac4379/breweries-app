//
//  MapView.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//

import Foundation
import MapKit
import CoreLocation

class MapView: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D?

    func fetchCoordinates(for address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
            guard let location = placemarks?.first?.location else { return }
            DispatchQueue.main.async {
                self?.coordinate = location.coordinate
            }
        }
    }
}
