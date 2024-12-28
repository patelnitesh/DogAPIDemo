# Dog API Demo

## Overview

**Dog API Demo** is a Swift-based iOS application that provides users with information about different dog breeds. The app fetches breed data and images using the Dog CEO API. The application demonstrates key iOS development concepts such as MVVM architecture, Swift Concurrency with `async/await`, Combine framework, and unit testing using `XCTest`.

## Features

- Display a list of all dog breeds.
- Search functionality to filter breeds based on user input.
- Fetch and display images of dog breeds.
- Image gallery view with swipeable pages.
- Error handling and loading states to improve user experience.

## Architecture

This project follows the MVVM (Model-View-ViewModel) architecture pattern, which helps to keep the code organized, modular, and easier to test.

- **Model**: Contains the data structures for DogBreed, DogBreedImage, and API responses.
- **View**: SwiftUI views that present the data.
- **ViewModel**: Manages the state and logic of the views by interacting with the API service.

## Installation

### Prerequisites

- Xcode 14 or later
- iOS 15 or later
- Swift 5.5 or later

### Clone the Repository

```bash
git clone https://github.com/patelnitesh/DogAPIDemo.git
cd DogDemo
```

### Dependencies

This project does not currently use any external dependencies. All code is self-contained within the project.

## Usage

1. Run the project on an iOS simulator or a physical device.
2. The app will automatically fetch a list of all dog breeds from the Dog CEO API.
3. Use the search bar to filter dog breeds by name.
4. Select a breed to view a gallery of images associated with that breed. The gallery supports swipe gestures to browse through images.

## Image Gallery

The image gallery displays pictures of the selected dog breed using a `TabView` with swipeable pages. Each page shows an image fetched from the Dog CEO API. The gallery includes:

- **AsyncImage** for loading images asynchronously.
- **Combine API** for downloading breed images with publishers and subscribers.
- **TabView** with `PageTabViewStyle` for paging through images.
- **Hidden tab dots** to keep the interface clean.

## API Integration

The app uses the [Dog CEO API](https://dog.ceo/dog-api/documentation/) to fetch data about dog breeds and their images. The `DogAPIService` class is responsible for making network requests and decoding the JSON responses.

### Endpoints

- **List All Breeds**: `/breeds/list/all`
- **Random Images for a Breed**: `/breed/{breed}/{subBreed}/images/random/{count}`
- **List Sub Breeds**: `/breed/{breed}/list`

## Combine API for Image Downloads

The app now uses the Combine framework to fetch breed images through a new API method:

```swift
func fetchBreedImagesWithCombine(breed: DogBreed, count: Int) -> AnyPublisher<[BreedImage], DogAPIError>
```

This approach allows for a more reactive and streamlined way to handle image fetching by subscribing to publishers and managing state with Combine pipelines.

## Unit Testing

Unit tests are written using `XCTest` to ensure the correct behavior of the ViewModels and API services. Mock services are used to simulate API responses for testing purposes.

### Running Tests

1. Open the `DogAPIDemo.xcodeproj` in Xcode.
2. Select the `DogAPIDemoTests` scheme.
3. Press `Cmd+U` to run the tests.

### Example Test for Combine API

An example of a unit test is included for the Combine-based image fetch API to verify both success and failure cases:

```swift
func testFetchBreedImagesWithCombine_Success() {
    let expectation = XCTestExpectation(description: "Successfully fetch breed images using Combine")
    mockDogApiService.mockImages = [
        BreedImage(imageUrl: "https://example.com/image1.jpg"),
        BreedImage(imageUrl: "https://example.com/image2.jpg")
    ]

    mockDogApiService.fetchBreedImagesWithCombine(breed: mockDogBreed, count: 2)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure:
                XCTFail("Expected success but got failure.")
            case .finished:
                expectation.fulfill()
            }
        }, receiveValue: { images in
            XCTAssertEqual(images.count, 2, "Expected 2 images but got \(images.count).")
        })
        .store(in: &cancellables)

    wait(for: [expectation], timeout: 10.0)
}
```

## Error Handling

The app includes basic error handling for network requests, such as checking for a valid URL, handling invalid HTTP responses, and handling JSON decoding errors. Errors are displayed to the user via a text label.

## Contributing

Contributions are welcome! Please fork this repository, create a new branch, and submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or feedback, please contact Nitesh Patel.
