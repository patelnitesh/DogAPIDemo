//
//  DogAPIServiceTests.swift
//  DogAPIDemoTests
//
//  Created by Nitesh Patel on 21/08/2024.
//

import XCTest
@testable import DogAPIDemo

class DogAPIServiceTests: XCTestCase {
    var mockService: MockDogAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockDogAPIService()
    }

    func testFetchDogBreedsCalled() async {
        // Given
        // Ensure the mock service is correctly initialized

        // When
        do {
            let response = try await mockService.fetchDogBreeds()

            // Then
            XCTAssertTrue(mockService.fetchDogBreedsCalled, "fetchDogBreeds should be called.")
            XCTAssertEqual(response.message.count, 2, "There should be 2 breeds.")
            XCTAssertEqual(response.message["labrador"]?.count, 1, "Labrador breed should have 1 sub-breed.")
            XCTAssertEqual(response.message["bulldog"]?.count, 0, "Bulldog breed should have 0 sub-breeds.")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }

    func testFetchBreedImagesCalled() async {
        // Given
        let mockBreed = DogBreed(breed: "labrador")
        let count = 3

        // When
        do {
            let images = try await mockService.fetchBreedImages(breed: mockBreed, count: count)

            // Then
            XCTAssertTrue(mockService.fetchBreedImagesCalled, "fetchBreedImages should be called.")
            XCTAssertEqual(images.count, 3, "There should be 3 images.")
            XCTAssertEqual(images[0].imageUrl,"https://example.com/image1.jpg", "The first image URL should match.")
            XCTAssertEqual(images[1].imageUrl, "https://example.com/image2.jpg", "The second image URL should match.")
            XCTAssertEqual(images[2].imageUrl, "https://example.com/image3.jpg", "The third image URL should match.")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
}
