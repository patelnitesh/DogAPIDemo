//
//  DogBreedDetailsView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import SwiftUI

struct DogBreedDetailsView: View {
    let dogBreed: DogBreed
    
    init(dogBreed: DogBreed){
        self.dogBreed = dogBreed
    }
    
    var body: some View {
        Text(dogBreed.displayname)
    }
}

#Preview {
    DogBreedDetailsView(dogBreed: DogBreed(breed: "DogBreed"))
}
