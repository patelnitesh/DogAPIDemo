//
//  MockDogAPIService.swift
//  DogAPIDemoTests
//
//  Created by Nitesh Patel on 21/08/2024.
//

import XCTest
@testable import DogAPIDemo

class MockDogAPIService: DogAPIServiceProtocol {
    var fetchDogBreedsCalled = false
    var fetchBreedImagesCalled = false
    var shouldReturnError = false
    var mockImages: [DogBreedImage] = []

    func fetchDogBreeds() async throws -> DogBreedResponse {
        fetchDogBreedsCalled = true
        
        if shouldReturnError {
            // Simulate an error
            throw URLError(.badServerResponse)
        }
        
        // Return a mock response
        let mockResponse = DogBreedResponse(message: [
            "labrador": ["golden"],
            "bulldog": []
        ], status: "success")
        
        return mockResponse
    }
    
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [DogBreedImage] {
        fetchBreedImagesCalled = true
        // Return a mock list of image URLs
        
        if shouldReturnError {
            // Simulate an error
            throw URLError(.badServerResponse)
        }
        
        let tempImages = [
            DogBreedImage(imageUrl: "https://example.com/image1.jpg"),
            DogBreedImage(imageUrl: "https://example.com/image2.jpg"),
            DogBreedImage(imageUrl: "https://example.com/image3.jpg")
        ]
        
        return mockImages.isEmpty ?  tempImages : mockImages
    }
}
