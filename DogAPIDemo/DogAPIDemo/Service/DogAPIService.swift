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

enum DogAPIError: Error {
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
        print(url)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DogAPIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(DogBreedResponse.self, from: data)
        } catch {
            throw DogAPIError.decodingError
        }
    }
    
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [DogBreedImage] {
        guard let url = DogAPIEndpoint.randomImages(breed: breed, count: count).url else {
            throw URLError(.badURL)
        }
        print(url)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DogAPIError.invalidResponse
        }
        
        do {
            let imageResponse = try JSONDecoder().decode(DogImageResponse.self, from: data)
            print(imageResponse.message.count)
            return imageResponse.message.map { DogBreedImage(imageUrl: $0) }
        } catch {
            throw DogAPIError.decodingError
        }
    }
}
