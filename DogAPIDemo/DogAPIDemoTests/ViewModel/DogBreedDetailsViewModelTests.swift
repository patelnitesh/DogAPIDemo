//
//  DogBreedDetailsViewModelTests.swift
//  DogAPIDemoTests
//
//  Created by Nitesh Patel on 21/08/2024.
//

import XCTest
import Combine
@testable import DogAPIDemo

class DogBreedDetailsViewModelTests: XCTestCase {

    var subject: DogBreedDetailsViewModel!
    var mockDogApiService: MockDogAPIService!
    var mockDogBreed: DogBreed!
    var cancellables: Set<AnyCancellable> = []


    override func setUp() {
        super.setUp()
        mockDogApiService = MockDogAPIService()
        mockDogBreed = DogBreed(breed: "labrador", subBreeds: [], parentBreedName: "Retriever")
        subject = DogBreedDetailsViewModel(dogBreed: mockDogBreed, numberOfImagesToFetch: 2, dogAPIService: mockDogApiService)
    }

    override func tearDown() {
        mockDogApiService = nil
        subject = nil
        cancellables.removeAll()
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
    
    
    // Combine Tests
    func testFetchBreedImagesWithCombine_Success() {
        // Given
        mockDogApiService.mockImages = [
            BreedImage(imageUrl: "https://example.com/success1.jpg"),
            BreedImage(imageUrl: "https://example.com/success2.jpg")
        ]
        
        let expectation = XCTestExpectation(description: "Successfully fetch breed images using Combine")
        
        // When
        mockDogApiService
            .fetchBreedImagesWithCombine(breed: mockDogBreed, count: 2)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail("Expected success but got failure.")
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            }, receiveValue: { images in
                // Then
                XCTAssertEqual(images.count, 2, "Expected 2 images but got \(images.count).")
                XCTAssertEqual(images.first?.imageUrl, "https://example.com/success1.jpg", "First image URL mismatch.")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchBreedImagesWithCombine_Failure() {
        // Given
        mockDogApiService.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Fail to fetch breed images using Combine")
        
        // When
        mockDogApiService
            .fetchBreedImagesWithCombine(breed: mockDogBreed, count: 2)
            .receive(on: DispatchQueue.main)  // Ensure errors are handled on the main thread
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Then
                    XCTAssertEqual(error, .decodingError, "Expected decoding error.")
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure but got success.")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("No value should be received on failure.")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }

}

