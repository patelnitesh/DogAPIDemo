//
//  DogBreedDetailsViewModel.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Observation
import SwiftUI

@Observable class DogBreedDetailsViewModel {
    var breedImages: [BreedImage] = []
    let dogBreed: DogBreed
    let numberOfImagesToFetch: Int
    let dogAPIService: DogAPIServiceProtocol
    
    var state: DogResultState = .loading

    init(dogBreed: DogBreed, numberOfImagesToFetch: Int = 10, dogAPIService: DogAPIServiceProtocol) {
        self.dogAPIService = dogAPIService
        self.dogBreed = dogBreed
        self.numberOfImagesToFetch = numberOfImagesToFetch
        Task {
            await fetchBreedImages()
        }
    }
    
    func fetchBreedImages() async {
        state = .loading
        do {
            breedImages = try await dogAPIService.fetchBreedImages(breed: dogBreed, count: numberOfImagesToFetch)
            state = .success
        } catch {
            breedImages = []
            guard let error = error as? DogAPIError else {
                return
            }
            self.state = .failed(error)

        }
    }
    
    var displayName: String {
        if let parentname = dogBreed.parentBreedName {
            return parentname.capitalized + " - " + dogBreed.displayName
        }
        return dogBreed.displayName
    }
}
