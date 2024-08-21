//
//  DogBreedListViewModel.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Observation
import SwiftUI

@Observable class DogBreedListViewModel {
    var dogBreeds: [DogBreed] = []
    var filteredBreeds: [DogBreed] = []
    
    var isLoading = false
    var error: Error?
    var searchText: String = "" {
           didSet {
               filterDogBreeds()
           }
       }
    
    let dogAPIService: DogAPIServiceProtocol
    
    init(dogAPIService: DogAPIServiceProtocol) {
        self.dogAPIService = dogAPIService
        Task {
            await fetchDogBreeds()
        }
    }
    
    func fetchDogBreeds() async {
        isLoading = true
        do {
            let response = try await dogAPIService.fetchDogBreeds()
            self.dogBreeds = response.message.map { breed, subBreeds in
                DogBreed(breed: breed, subBreeds: subBreeds.sorted()) }
            .sorted(by: { $0.name < $1.name })
            self.filterDogBreeds()
        } catch {
            self.error = error
            self.dogBreeds = []
            self.filterDogBreeds()
        }
        isLoading = false
    }
    
    func filterDogBreeds() {
        if !searchText.isEmpty {
            filteredBreeds = dogBreeds.filter { breed in
                // Check if the main breed matches the search text
                let matchesBreed = breed.name.localizedCaseInsensitiveContains(searchText)
                
                // Check if any sub-breeds match the search text
                let matchesSubBreed = breed.subBreeds?.contains(where: { subBreed in
                    subBreed.name.localizedCaseInsensitiveContains(searchText)
                }) ?? false
                
                return matchesBreed || matchesSubBreed
            }
        } else {
            filteredBreeds = dogBreeds
        }
    }
    // TODO: show only sub breed which is search for. e.g.
    // e.g. "hr" should show Australian/shepherd only and ingore Australian/kelpie
}
