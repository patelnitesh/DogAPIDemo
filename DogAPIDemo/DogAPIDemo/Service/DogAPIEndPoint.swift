//
//  DogAPIEndPoint.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Foundation

protocol APIBuilder {
    var baseUrl: String { get }
    var path: String { get }
    var url: URL? { get }
}

enum DogAPIEndpoint {
    case listAllBreeds
    case randomImages(breed: DogBreed, count: Int)
    case listSubBreeds(_ breed: String)
}

extension DogAPIEndpoint: APIBuilder {
    
    var baseUrl: String {
        return "https://dog.ceo/api"
    }
    
    var path: String {
        switch self {
        case .listAllBreeds:
            return "/breeds/list/all"
        case .randomImages(let breed, let count):
            let breedPath = breed.parentBreedName.map { "\($0)/\(breed.name)" } ?? breed.name
            return "/breed/\(breedPath)/images/random/\(count)"
        case .listSubBreeds(let breed):
            return "/breed/\(breed)/list"
        }
    }
    
    var url: URL? {
        URL(string: self.baseUrl)?.appendingPathComponent(self.path)
    }
    
}
