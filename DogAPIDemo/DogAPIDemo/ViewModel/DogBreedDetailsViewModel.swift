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
    let numberOfImagesToFetch: Int
    let dogAPIService: DogAPIServiceProtocol
    

    init(dogBreed: DogBreed, numberOfImagesToFetch: Int = 10, dogAPIService: DogAPIServiceProtocol) {
        self.dogAPIService = dogAPIService
        self.dogBreed = dogBreed
        self.numberOfImagesToFetch = numberOfImagesToFetch
        Task {
            await fetchBreedImages()
        }
    }
    
    func fetchBreedImages() async {
        isLoading = true
        do {
            breedImages = try await dogAPIService.fetchBreedImages(breed: dogBreed, count: numberOfImagesToFetch)
        } catch {
            self.error = error
            breedImages = []
        }
        isLoading = false
    }
    
    var displayName: String {
        if let parentname = dogBreed.parentBreedName {
            return parentname.capitalized + " - " + dogBreed.displayName
        }
        return dogBreed.displayName
    }
}
