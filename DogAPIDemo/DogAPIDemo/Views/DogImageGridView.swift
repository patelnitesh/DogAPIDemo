//
//  ImageGridView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 19/12/2024.
//
import SwiftUI

struct DogImageGridView: View {
    let imageUrls: [BreedImage]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var currentImage: String = ""
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(imageUrls, id: \.self) { breedImage in
                    NavigationLink(destination: DogBreedImageGalleryView(breedImages: imageUrls,
                                                                         currentImage: $currentImage,
                                                                         selectedImage: breedImage)) {
                        AsyncImage(url: URL(string: breedImage.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 150)
                        }
                        .tag(breedImage.id)
                    }
                }
            }
        }
        .padding()
    }
}
