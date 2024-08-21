//
//  DogBreedImage.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Foundation

struct DogBreedImage: Identifiable, Hashable {
    let id = UUID().uuidString
    let imageUrl: String
}
