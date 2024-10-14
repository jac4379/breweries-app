//
//  ContentView.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var breweryService = BreweryService()

    var body: some View {
        NavigationView {
            List(breweryService.breweries) { brewery in
                NavigationLink(destination: BreweryDetailView(brewery: brewery)) {
                    VStack(alignment: .leading) {
                        Text(brewery.name)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("🍻 Breweries")
            .onAppear {
                breweryService.fetchBreweries()
            }
        }
    }
}

#Preview {
    ContentView()
}
