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
    
    init(dogBreed: DogBreed) {
        viewModel = DogBreedDetailsViewModel(dogBreed: dogBreed, dogAPIService: DogAPIService.shared)
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            case .success:
                DogImageGridView(imageUrls: viewModel.breedImages)
            case .failed(let error):
                Text("Handled Error, \(error.localizedDescription)")
            }
        }
        .navigationTitle(viewModel.displayName)
    }
}

#Preview {
    DogBreedDetailsView(dogBreed: DogBreed(breed: "airedale"))
}


