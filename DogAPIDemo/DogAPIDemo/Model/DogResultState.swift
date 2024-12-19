//
//  ResultState.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 19/12/2024.
//

enum DogResultState: Equatable {
    case loading
    case success
    case failed(DogAPIError)
}
