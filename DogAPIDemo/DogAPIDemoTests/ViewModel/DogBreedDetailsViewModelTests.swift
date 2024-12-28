//
//  DogBreedDetailsViewModelTests.swift
//  DogAPIDemoTests
//
//  Created by Nitesh Patel on 21/08/2024.
//

import XCTest
@testable import DogAPIDemo

class DogBreedDetailsViewModelTests: XCTestCase {

    var subject: DogBreedDetailsViewModel!
    var mockDogApiService: MockDogAPIService!
    var mockDogBreed: DogBreed!

    override func setUp() {
        super.setUp()
        mockDogApiService = MockDogAPIService()
        mockDogBreed = DogBreed(breed: "labrador", subBreeds: [], parentBreedName: "Retriever")
        subject = DogBreedDetailsViewModel(dogBreed: mockDogBreed, numberOfImagesToFetch: 2, dogAPIService: mockDogApiService)
    }

    override func tearDown() {
        mockDogApiService = nil
        subject = nil
        super.tearDown()
    }

    func testFetchBreedImagesSuccess() async {
        // Given
        mockDogApiService.mockImages = [
            BreedImage(imageUrl: "https://example.com/image1.jpg"),
            BreedImage(imageUrl: "https://example.com/image2.jpg")
        ]

        // When
        await subject.fetchBreedImages()

        // Then
        XCTAssertTrue(mockDogApiService.fetchBreedImagesCalled, "fetchBreedImages should be called.")
        XCTAssertEqual(subject.state, .success, "State should be success after fetching images.")
        XCTAssertEqual(subject.breedImages.count, 2, "There should be 2 images fetched.")
    }

    func testFetchBreedImagesFailure() async {
        // Given
        mockDogApiService.shouldReturnError = true

        // When
        await subject.fetchBreedImages()

        // Then
        XCTAssertTrue(mockDogApiService.fetchBreedImagesCalled, "fetchBreedImages should be called.")
        XCTAssertEqual(subject.state, .failed(.decodingError), "State should reflect a decoding error.")
        XCTAssertTrue(subject.breedImages.isEmpty, "There should be no images when fetching fails.")
    }
    
    func testDisplayName() {
        // Given
        let parentBreedName = "Retriever"
        mockDogBreed.parentBreedName = parentBreedName
        
        subject = DogBreedDetailsViewModel(dogBreed: mockDogBreed, numberOfImagesToFetch: 2, dogAPIService: mockDogApiService)

        // When
        let displayName = subject.displayName

        // Then
        XCTAssertEqual(displayName, "\(parentBreedName.capitalized) - \(mockDogBreed.displayName)", "Display name should be formatted as 'Retriever - Labrador'.")
    }
}

