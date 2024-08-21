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
    
    var isLoading = false
    var error: Error?
    
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
        } catch {
            self.error = error
            self.dogBreeds = []
        }
        isLoading = false
    }
    
}
