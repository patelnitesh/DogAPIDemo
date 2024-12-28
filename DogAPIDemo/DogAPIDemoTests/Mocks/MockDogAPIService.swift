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
    var shouldReturnError = false
    
    var mockResponse: DogAPIDemo.DogBreedResponse = DogBreedResponse(
        message: [
            "Australian": ["shepherd", "kelpie"],
            "Beagle": []
        ],
        status: "success"
    )
    
    var fetchBreedImagesCalled = false
    var mockImages: [BreedImage] = []
    
    func fetchDogBreeds() async throws -> DogAPIDemo.DogBreedResponse {
        fetchDogBreedsCalled = true
        if shouldReturnError {
            throw DogAPIError.decodingError
        }
        return mockResponse
    }
    
    func fetchBreedImages(breed: DogBreed, count: Int) async throws -> [BreedImage] {
        fetchBreedImagesCalled = true
        // Return a mock list of image URLs
        
        if shouldReturnError {
            // Simulate an error
            throw DogAPIError.decodingError
        }
        
        let tempImages = [
            BreedImage(imageUrl: "https://example.com/image1.jpg"),
            BreedImage(imageUrl: "https://example.com/image2.jpg"),
            BreedImage(imageUrl: "https://example.com/image3.jpg")
        ]
        
        return mockImages.isEmpty ?  tempImages : mockImages
    }
}
