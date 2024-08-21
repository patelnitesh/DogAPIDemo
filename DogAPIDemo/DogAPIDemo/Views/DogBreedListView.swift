//
//  DogBreedListView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import SwiftUI

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
                        NavigationLink(value: breed) {
                            Text(breed.displayname)
                        }
                    }
                }
                .navigationTitle("Dog Breeds")
            }
        }
    }
}

#Preview {
    DogBreedListView()
}
