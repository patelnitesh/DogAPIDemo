//
//  DogBreedResponse.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Foundation

struct DogBreedResponse: Decodable {
    let message: [String: [String]]
    let status: String
}
