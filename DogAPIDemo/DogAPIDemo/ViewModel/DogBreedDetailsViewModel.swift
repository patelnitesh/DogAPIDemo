//
//  DogBreedDetailsViewModel.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Observation
import SwiftUI
import Combine

@Observable class DogBreedDetailsViewModel {
    var breedImages: [BreedImage] = []
    let dogBreed: DogBreed
    let numberOfImagesToFetch: Int
    let dogAPIService: DogAPIServiceProtocol
    
    var state: DogResultState = .loading
    private var cancellables = Set<AnyCancellable>()


    init(dogBreed: DogBreed, numberOfImagesToFetch: Int = 10, dogAPIService: DogAPIServiceProtocol) {
        self.dogAPIService = dogAPIService
        self.dogBreed = dogBreed
        self.numberOfImagesToFetch = numberOfImagesToFetch
        // Uncomment these if you want use Async/Await
//        Task {
//            await fetchBreedImages()
//        }
        
        fetchBreedImagesUsingCombine()
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
    
    func fetchBreedImagesUsingCombine() {
        state = .loading
        
        dogAPIService.fetchBreedImagesWithCombine(breed: dogBreed, count: numberOfImagesToFetch)
            .receive(on: DispatchQueue.main)  // Ensure updates happen on the main thread for UI
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.breedImages = []
                    self?.state = .failed(error)
                case .finished:
                    self?.state = .success
                }
            }, receiveValue: { [weak self] images in
                self?.breedImages = images
            })
            .store(in: &cancellables)
    }
    
    var displayName: String {
        if let parentname = dogBreed.parentBreedName {
            return parentname.capitalized + " - " + dogBreed.displayName
        }
        return dogBreed.displayName
    }
}
