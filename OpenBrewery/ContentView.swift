//
//  ContentView.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//
/*
 I wanted to make the list view more interesting since this kind of list
 has been used so often in assignments, but I didn't really know what to
 do to change it up, so I left it plain.
 */

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
