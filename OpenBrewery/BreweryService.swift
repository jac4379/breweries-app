//
//  BreweryService.swift
//  OpenBrewery
//
//  Created by Jacqueline on 10/9/24.
//

import Foundation

class BreweryService: ObservableObject {
    @Published var breweries: [Brewery] = []

    func fetchBreweries() {
        guard let url = URL(string: "https://api.openbrewerydb.org/v1/breweries") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let breweriesResponse = try JSONDecoder().decode([Brewery].self, from: data)
                DispatchQueue.main.async {
                    self.breweries = breweriesResponse
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }
}
