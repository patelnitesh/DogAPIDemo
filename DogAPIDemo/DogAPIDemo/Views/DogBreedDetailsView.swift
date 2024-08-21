//
//  DogBreedDetailsView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import SwiftUI

/// Show  10 random images of given dog breed.
/// By images will display in gallery layout
///
struct DogBreedDetailsView: View {
    private var viewModel: DogBreedDetailsViewModel
    @State private var currentImage: String = ""

    init(dogBreed: DogBreed) {
        viewModel = DogBreedDetailsViewModel(dogBreed: dogBreed, dogAPIService: DogAPIService.shared)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let error = viewModel.error {
                Text("Error loading images: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.breedImages.isEmpty {
                Text("No images available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                DogBreedImageGalleryView(breedImages: viewModel.breedImages, currentImage: $currentImage)
            }
        }
        .navigationTitle(viewModel.displayName)
        
    }
}

#Preview {
    DogBreedDetailsView(dogBreed: DogBreed(breed: "airedale"))
}
