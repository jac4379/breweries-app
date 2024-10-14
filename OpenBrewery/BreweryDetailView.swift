//
//  BreweryDetailView.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//

import SwiftUI
import MapKit
import CoreLocation

// Create a struct to represent the map annotation
struct MapAnnotationItem: Identifiable {
    let id = UUID() // Unique identifier
    var coordinate: CLLocationCoordinate2D
}

struct BreweryDetailView: View {
    @StateObject private var mapViewModel = MapView()
    let brewery: Brewery

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            if let coordinate = mapViewModel.coordinate {
                let annotationItem = MapAnnotationItem(coordinate: coordinate)
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                    annotationItems: [annotationItem]) { item in
                        MapMarker(coordinate: item.coordinate, tint: .red)
                    }
                .frame(height: 300) // Set the height of the map
                .cornerRadius(10)
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
                        .onAppear {
                            mapViewModel.fetchCoordinates(for: address)
                        }
                }
            }
            
            if let tel = brewery.phone {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.blue)
                    Text(formatPhoneNumber(tel))
                }
            }
            
            HStack {
                //Spacer()
                if let websiteUrlString = brewery.websiteUrl, let websiteUrl = URL(string: websiteUrlString) {
                    Image(systemName: "network")
                        .foregroundColor(.blue)    // just here to provide the exact amount of empty space
                    Link("Visit Website", destination: websiteUrl)
                        .font(.headline)
                        .foregroundColor(.blue)
                        //.padding()
                }
                //Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Brewery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
            let numbers = phoneNumber.compactMap { $0.isNumber ? String($0) : nil }.joined()
            
            guard numbers.count == 10 else {
                return phoneNumber // Return unformatted if not 10 digits
            }
            
            let areaCode = numbers.prefix(3)
            let centralOfficeCode = numbers[numbers.index(numbers.startIndex, offsetBy: 3)..<numbers.index(numbers.startIndex, offsetBy: 6)]
            let lineNumber = numbers.suffix(4)
            
            return "(\(areaCode)) \(centralOfficeCode)-\(lineNumber)"
        }
}

#Preview {
    // Use a sample brewery for preview
        let sampleBrewery = Brewery(
            id: "5128df48-79fc-4f0f-8b52-d06be54d0cec",
            name: "(405) Brewing Co",
            breweryType: "micro",
            street: "1716 Topeka St",
            city: "Norman",
            state: "Oklahoma",
            postalCode: "73069-8224",
            phone: "4058160490",
            websiteUrl: "http://www.405brewing.com"
        )
        
        BreweryDetailView(brewery: sampleBrewery)
}
