//
//  DogAPIEndpointTests.swift
//  DogAPIDemoTests
//
//  Created by Nitesh Patel on 21/08/2024.
//

import XCTest
@testable import DogAPIDemo

class DogAPIEndpointTests: XCTestCase {

    func testListAllBreedsEndpoint() {
        // Given
        let endpoint = DogAPIEndpoint.listAllBreeds

        // When
        let url = endpoint.url

        // Then
        XCTAssertEqual(endpoint.baseUrl, "https://dog.ceo/api", "Base URL should be correct.")
        XCTAssertEqual(endpoint.path, "/breeds/list/all", "Path for listAllBreeds should be correct.")
        XCTAssertEqual(url?.absoluteString, "https://dog.ceo/api/breeds/list/all", "URL for listAllBreeds should be correct.")
    }

    func testRandomImagesEndpointWithParentBreed() {
        // Given
        let breed = DogBreed(breed: "shepherd", parentBreedName: "australian")
        let endpoint = DogAPIEndpoint.randomImages(breed: breed, count: 5)

        // When
        let url = endpoint.url

        // Then
        XCTAssertEqual(endpoint.baseUrl, "https://dog.ceo/api", "Base URL should be correct.")
        XCTAssertEqual(endpoint.path, "/breed/australian/shepherd/images/random/5", "Path for randomImages with sub-breed should be correct.")
        XCTAssertEqual(url?.absoluteString, "https://dog.ceo/api/breed/australian/shepherd/images/random/5", "URL for randomImages with sub-breed should be correct.")
    }

    func testRandomImagesEndpointWithoutSubBreed() {
        // Given
        let breed = DogBreed(breed: "labrador", subBreeds: [])
        let endpoint = DogAPIEndpoint.randomImages(breed: breed, count: 3)

        // When
        let url = endpoint.url

        // Then
        XCTAssertEqual(endpoint.baseUrl, "https://dog.ceo/api", "Base URL should be correct.")
        XCTAssertEqual(endpoint.path, "/breed/labrador/images/random/3", "Path for randomImages without sub-breed should be correct.")
        XCTAssertEqual(url?.absoluteString, "https://dog.ceo/api/breed/labrador/images/random/3", "URL for randomImages without sub-breed should be correct.")
    }

    func testListSubBreedsEndpoint() {
        // Given
        let breedName = "bulldog"
        let endpoint = DogAPIEndpoint.listSubBreeds(breedName)

        // When
        let url = endpoint.url

        // Then
        XCTAssertEqual(endpoint.baseUrl, "https://dog.ceo/api", "Base URL should be correct.")
        XCTAssertEqual(endpoint.path, "/breed/bulldog/list", "Path for listSubBreeds should be correct.")
        XCTAssertEqual(url?.absoluteString, "https://dog.ceo/api/breed/bulldog/list", "URL for listSubBreeds should be correct.")
    }
}
