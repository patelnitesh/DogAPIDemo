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
    
    func testInitialState() {
        // Then
        XCTAssertEqual(subject.dogBreeds.count, 0, "Initial dog breeds should be empty.")
        XCTAssertEqual(subject.filteredBreeds.count, 0, "Initial filtered breeds should be empty.")
        XCTAssertEqual(subject.state, .loading, "Initial state should be loading.")
    }

    func testStateTransitionOnSuccess() async {
        // When
        await subject.fetchDogBreeds()
        
        // Then
        XCTAssertEqual(subject.state, .success, "State should be success after a successful fetch.")
    }

        
    func testFetchDogBreedsSuccess() async {
        // When
        await subject.fetchDogBreeds()

        // Then
        XCTAssertTrue(mockDogApiService.fetchDogBreedsCalled, "fetchDogBreeds should be called.")
        XCTAssertEqual(subject.dogBreeds.count, 2, "Expected 2 breeds, but got \(subject.dogBreeds.count).")
        XCTAssertEqual(subject.filteredBreeds.count, 2, "Expected 2 Filterd breeds, but got \(subject.filteredBreeds.count).")
    }
    
    func testFetchDogBreedsEmptyResponse() async {
        // Given
        mockDogApiService.mockResponse = DogBreedResponse(
                message: [:],  // Simulate empty breeds
                status: "success"
            )

        // When
        await subject.fetchDogBreeds()

        // Then
        XCTAssertEqual(subject.dogBreeds.count, 0, "Dog breeds should be empty when API returns no data.")
        XCTAssertEqual(subject.filteredBreeds.count, 0, "Filtered breeds should also be empty.")
        XCTAssertEqual(subject.state, .success, "State should be success even if no breeds are returned.")
    }

    
    func testFetchDogBreedsFailure() async {
        // Given
        mockDogApiService.shouldReturnError = true

        // When
        await subject.fetchDogBreeds()

        // Then
        XCTAssertTrue(mockDogApiService.fetchDogBreedsCalled, "fetchDogBreeds should be called.")
        XCTAssertEqual(subject.state, .failed(.decodingError), "The state should reflect a decoding error.")

        XCTAssertEqual(subject.dogBreeds.count, 0, "There should be 0 breeds when an error occurs.")
        XCTAssertEqual(subject.filteredBreeds.count, 0, "There should be 0 filtered breeds when an error occurs.")
    }
    
    func testFetchDogBreedsDynamicResponse() async {
        // Given
        mockDogApiService.mockResponse = DogBreedResponse(
            message: [
                "Labrador": ["retriever"]  // Simulate dynamic breed response
            ],
            status: "success"
        )
        
        // When
        await subject.fetchDogBreeds()
        
        // Then
        XCTAssertEqual(subject.dogBreeds.count, 1, "Expected 1 breed.")
        XCTAssertEqual(subject.dogBreeds.first?.name, "Labrador", "Breed name should match.")
        XCTAssertEqual(subject.dogBreeds.first?.subBreeds?.first?.name, "retriever", "Sub-breed name should match.")
    }
    
    func testSearchTextFiltering() async {
        // Given
        await subject.fetchDogBreeds()
        subject.searchText = "shepherd"
        
        // Then
        XCTAssertEqual(subject.filteredBreeds.count, 1, "Filtered breeds should only include those matching the search text.")
        XCTAssertEqual(subject.filteredBreeds.first?.name, "Australian", "The breed name should match 'Australian'.")
        let subBreedNames = subject.filteredBreeds.first?.subBreeds?.map { $0.name }
        XCTAssertTrue(subBreedNames?.contains("shepherd") ?? false, "The sub-breed name should match 'shepherd'.")
    }
}
