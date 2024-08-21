//
//  DogBreedDetailsViewModel.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Observation
import SwiftUI

@Observable class DogBreedDetailsViewModel {
    var breedImages: [DogBreedImage] = []
    var isLoading = false
    var error: Error?
    
    let dogBreed: DogBreed
    let dogAPIService: DogAPIServiceProtocol
    

    init(dogBreed: DogBreed, dogAPIService: DogAPIServiceProtocol) {
        self.dogAPIService = dogAPIService
        self.dogBreed = dogBreed
        Task {
            await fetchBreedImages()
        }
    }
    
    func fetchBreedImages() async {
        isLoading = true
        do {
            breedImages = try await dogAPIService.fetchBreedImages(breed: dogBreed, count: 10)
        } catch {
            self.error = error
            breedImages = []
        }
        isLoading = false
    }
}
