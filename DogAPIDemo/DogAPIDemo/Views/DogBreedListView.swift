//
//  DogBreedListView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import SwiftUI

/// Show list of dog breed and subbreed

struct DogBreedListView: View {
   
    private var viewModel = DogBreedListViewModel(dogAPIService: DogAPIService.shared)
    
    @State var searchText: String = ""
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        } else if let error = viewModel.error {
            Text("Handled Error, \(error.localizedDescription)")
        } else {
            NavigationStack {
                List {
                    ForEach(viewModel.dogBreeds) { breed in
                        if let subBreeds = breed.subBreeds, !subBreeds.isEmpty {
                            // Show expandable list for breeds with sub-breeds
                            DisclosureGroup {
                                ForEach(subBreeds) { subBreed in
                                    NavigationLink(value: subBreed) {
                                        Text(subBreed.displayname)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(breed.displayname)
                                    Text("(\(subBreeds.count))")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        else {
                            // Show detail view for breeds without sub-breeds
                            NavigationLink(value: breed) {
                                Text(breed.displayname)
                            }
                        }
                    }
                }
                .navigationTitle("Dog Breeds")
                .navigationDestination(for: DogBreed.self) { dogBreed in
                    DogBreedDetailsView(dogBreed: dogBreed)
                }
            }
        }
    }
}

#Preview {
    DogBreedListView()
}
