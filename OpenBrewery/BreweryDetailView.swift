//
//  BreweryDetailView.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//
// Comments within the file at relevant parts.

import SwiftUI
import MapKit
import CoreLocation

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct BreweryDetailView: View {
    @StateObject private var mapViewModel = MapView()
    let brewery: Brewery

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            /*
            Map is created using latitude and longitude, but if these are null, the address is used to make the map.
            This is because some elements have one or the other.
             
            Couldn't get Marker to work right, so just used the deprecated MapMarker since it at least works.
            I did use ChatGPT 4o mini to help me with this and the MapView because I spent the majority of
            my time trying to get it working right, so that's why they both look like they do. They work
            now so I didn't want to mess with it too much.
            */
            if let latitudeString = brewery.latitude,
               let longitudeString = brewery.longitude,
               let latitude = Double(latitudeString),
               let longitude = Double(longitudeString) {
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotationItem = MapAnnotationItem(coordinate: coordinate)
                
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                    annotationItems: [annotationItem]) { item in
                        MapMarker(coordinate: item.coordinate, tint: .red)
                    }
                .frame(height: 375)
                .cornerRadius(15)
            } else if let street = brewery.street, let city = brewery.city, let state = brewery.state, let zip = brewery.postalCode {
                let address = "\(street), \(city), \(state) \(zip)"
                
                VStack {
                    if let coordinate = mapViewModel.coordinate {
                        let annotationItem = MapAnnotationItem(coordinate: coordinate)
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                            annotationItems: [annotationItem]) { item in
                                MapMarker(coordinate: item.coordinate, tint: .red)
                            }
                        .frame(height: 375)
                        .cornerRadius(15)
                    } else {
                        Text("Location not available")
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    mapViewModel.fetchCoordinates(for: address)
                }
            } else {
                Text("Location not available")
                    .foregroundColor(.gray)
            }
            
            Text(brewery.name)
                .font(.title)
                .fontWeight(.bold)

            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.blue)
                Text(brewery.breweryType.capitalized)
            }

            if let street = brewery.street, let city = brewery.city, let state = brewery.state, let zip = brewery.postalCode {
                let address = "\(street), \(city), \(state) \(zip)"
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    Text(address)
                }
            }

            // wanted to have this as a link that opens the dialer when tapped, but that isn't functional in a build
            if let tel = brewery.phone {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.blue)
                    Text(formatPhoneNumber(tel))
                }
            }
            
            // link works in build only, not preview
            if let websiteUrlString = brewery.websiteUrl, let websiteUrl = URL(string: websiteUrlString) {
                HStack {
                    Image(systemName: "network")
                        .foregroundColor(.blue)
                    Link("Visit Website", destination: websiteUrl)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Brewery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    // there should really be an existing way to do this instead of having to make a function
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let numbers = phoneNumber.compactMap { $0.isNumber ? String($0) : nil }.joined()
        
        guard numbers.count == 10 else {
            return phoneNumber
        }
        
        let areaCode = numbers.prefix(3)
        let firstThree = numbers[numbers.index(numbers.startIndex, offsetBy: 3)..<numbers.index(numbers.startIndex, offsetBy: 6)]
        let lastFour = numbers.suffix(4)
        
        return "(\(areaCode)) \(firstThree)-\(lastFour)"
    }
}

let sampleBrewery = Brewery(
    id: "5128df48-79fc-4f0f-8b52-d06be54d0cec",
    name: "(405) Brewing Co",
    breweryType: "micro",
    street: "1716 Topeka St",
    city: "Norman",
    state: "Oklahoma",
    postalCode: "73069-8224",
    longitude: "-97.46818222",
    latitude: "35.25738891",
    phone: "4058160490",
    websiteUrl: "http://www.405brewing.com"
)

#Preview {
    BreweryDetailView(brewery: sampleBrewery)
}
