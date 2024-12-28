//
//  DogAPIService.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import Foundation
import Combine


protocol DogAPIServiceProtocol {
    func fetchDogBreeds() async throws -> DogBreedResponse
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [BreedImage]
    func fetchBreedImagesWithCombine(breed: DogBreed, count: Int) -> AnyPublisher<[BreedImage], DogAPIError>
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
    
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [BreedImage] {
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
            return imageResponse.message.map { BreedImage(imageUrl: $0) }
        } catch {
            throw DogAPIError.decodingError
        }
    }
    
    func fetchBreedImagesWithCombine(breed: DogBreed, count: Int) -> AnyPublisher<[BreedImage], DogAPIError> {
        guard let url = DogAPIEndpoint.randomImages(breed: breed, count: count).url else {
            return Fail(error: DogAPIError.invalidURL).eraseToAnyPublisher()
        }
        
        print(url)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw DogAPIError.invalidResponse
                }
                return data
            }
            .decode(type: DogImageResponse.self, decoder: JSONDecoder())
            .map { $0.message.map { BreedImage(imageUrl: $0) } }
            .mapError { error in
                (error as? DogAPIError) ?? .decodingError
            }
            .eraseToAnyPublisher()
    }
}
