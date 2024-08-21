//
//  DogBreedListViewModelTests.swift
//  DogAPIDemoTests
//
//  Created by Nitesh Patel on 21/08/2024.
//

import XCTest
@testable import DogAPIDemo

class DogBreedListViewModelTests: XCTestCase {
    
    var subject: DogBreedListViewModel!
    var mockDogApiService: MockDogAPIService!
    
    override func setUp() {
        super.setUp()
        mockDogApiService = MockDogAPIService()
        subject = DogBreedListViewModel(dogAPIService: mockDogApiService)
    }
    
    override func tearDown() {
        mockDogApiService = nil
        subject = nil
        super.tearDown()
    }
    
    func testFetchDogBreedsSuccess() async {
        // Create an expectation
        let expectation = XCTestExpectation(description: "fetchDogBreeds should be called and processed.")
        
        // Call the async method
        await subject.fetchDogBreeds()
        
        // Verify that the fetchDogBreeds method was called
        XCTAssertTrue(mockDogApiService.fetchDogBreedsCalled, "fetchDogBreeds should be called.")
        
        // Check if the dog breeds have been correctly populated
        XCTAssertEqual(subject.dogBreeds.count, 2, "There should be 2 breeds.")
        XCTAssertEqual(subject.filteredBreeds.count, 2, "There should be 2 breeds.")
        
        // Fulfill the expectation
        expectation.fulfill()
        
        // Wait for expectations
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testFetchDogBreedsFailure() async {
        // Given
        mockDogApiService.shouldReturnError = true

        // Create an expectation
        let expectation = XCTestExpectation(description: "fetchDogBreeds should handle errors.")

        // When
        await subject.fetchDogBreeds()

        // Then
        XCTAssertTrue(mockDogApiService.fetchDogBreedsCalled, "fetchDogBreeds should be called.")
        
        XCTAssertNotNil(subject.error, "An error should be present.")
        XCTAssertEqual(subject.dogBreeds.count, 0, "There should be 0 breeds.")
        XCTAssertEqual(subject.filteredBreeds.count, 0, "There should be 0 breeds.")

        // Fulfill the expectation
        expectation.fulfill()
        
        // Wait for expectations
        await fulfillment(of: [expectation], timeout: 5.0)
    }

}
