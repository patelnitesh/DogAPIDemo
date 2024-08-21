//
//  DogBreed.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Foundation

struct DogBreed: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var subBreeds: [DogBreed]?
    var parentBreedName: String?
    
    init(breed: String, subBreeds: [String] = [], parentBreedName: String? = nil) {
        self.name = breed
        self.parentBreedName = parentBreedName
        if subBreeds.isEmpty {
            self.subBreeds = nil
        } else {
            self.subBreeds = subBreeds.map { DogBreed(breed: $0, parentBreedName: breed) }
        }
    }
    
    var displayname: String {
        name.capitalized
    }
}
