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
        mockDogApiService.mockImages = [DogBreedImage(imageUrl: "https://example.com/image1.jpg"),
                                        DogBreedImage(imageUrl: "https://example.com/image2.jpg")]

        // When
        await subject.fetchBreedImages()

        // Then
        XCTAssertTrue(mockDogApiService.fetchBreedImagesCalled, "fetchBreedImages should be called.")
        XCTAssertFalse(subject.isLoading, "isLoading should be false after fetching images.")
        XCTAssertNil(subject.error, "Error should be nil on success.")
        XCTAssertEqual(subject.breedImages.count, 2, "There should be 2 images fetched.")
    }

    func testFetchBreedImagesFailure() async {
        // Given
        mockDogApiService.shouldReturnError = true
        
        // Create an expectation
        let expectation = XCTestExpectation(description: "fetchDogBreeds should handle errors.")

        // When
        await subject.fetchBreedImages()

        // Then
        XCTAssertTrue(mockDogApiService.fetchBreedImagesCalled, "fetchBreedImages should be called.")
        XCTAssertFalse(subject.isLoading, "isLoading should be false after attempting to fetch images.")
        XCTAssertNotNil(subject.error, "Error should be set when fetching images fails.")
        XCTAssertTrue(subject.breedImages.isEmpty, "There should be no images when fetching fails.")
        
        // Fulfill the expectation
        expectation.fulfill()
        
        // Wait for expectations
        await fulfillment(of: [expectation], timeout: 5.0)
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
