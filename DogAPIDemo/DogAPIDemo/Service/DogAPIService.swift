//
//  DogAPIService.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Foundation

protocol DogAPIServiceProtocol {
    func fetchDogBreeds() async throws -> DogBreedResponse
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [DogBreedImage]
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

class DogAPIService: DogAPIServiceProtocol {
    static let shared = DogAPIService()
    
    private init() {}
    
    func fetchDogBreeds() async throws -> DogBreedResponse {
        guard let url = DogAPIEndpoint.listAllBreeds.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(DogBreedResponse.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [DogBreedImage] {
        guard let url = DogAPIEndpoint.randomImages(breed: breed, count: count).url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let imagePaths = json?["message"] as? [String] ?? []
            return imagePaths.map { DogBreedImage(imageUrl: $0) }
        } catch {
            throw APIError.decodingError
        }
    }
}
