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
                    ForEach(viewModel.filteredBreeds) { breed in
                        if let subBreeds = breed.subBreeds, !subBreeds.isEmpty {
                            // Show expandable list for breeds with sub-breeds
                            DisclosureGroup {
                                ForEach(subBreeds) { subBreed in
                                    NavigationLink(value: subBreed) {
                                        Text(subBreed.displayName)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(breed.displayName)
                                    Text("(\(subBreeds.count))")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        else {
                            // Show detail view for breeds without sub-breeds
                            NavigationLink(value: breed) {
                                Text(breed.displayName)
                            }
                        }
                    }
                }
                .navigationTitle("Dog Breeds")
                .navigationDestination(for: DogBreed.self) { dogBreed in
                    DogBreedDetailsView(dogBreed: dogBreed)
                }
                .searchable(text: $searchText, placement: .automatic, prompt: "Filter breed, subbreed")
                .onChange(of: searchText) { oldValue, newValue in
                    viewModel.searchText = newValue
                }
            }
        }
    }
}

#Preview {
    DogBreedListView()
}
