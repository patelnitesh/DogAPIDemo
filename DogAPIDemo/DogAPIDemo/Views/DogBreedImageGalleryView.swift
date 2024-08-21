//
//  DogBreedImageGalleryView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import SwiftUI

struct DogBreedImageGalleryView: View {
    var breedImages: [DogBreedImage]
    @Binding var currentImage: String
    
    var body: some View {
        TabView(selection: $currentImage) {
            ForEach(breedImages, id: \.self) { breedImage in
                AsyncImage(url: URL(string: breedImage.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .id(breedImage.id)
                } placeholder: {
                    ProgressView()
                }
                .padding()
                .tag(breedImage.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear(){
            currentImage = breedImages.first?.id ?? ""
        }
        .overlay (alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(breedImages) { breedImage in
                            AsyncImage(url: URL(string: breedImage.imageUrl)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(12)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(Color.white, lineWidth: 2)
                                            .opacity(currentImage == breedImage.id ? 1 : 0)
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            currentImage = breedImage.id
                                        }
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.black.opacity(0.80)).ignoresSafeArea()
                .onChange(of: currentImage) {
                    withAnimation {
                        proxy.scrollTo(currentImage, anchor: .bottom)
                    }
                }
            }
        }
    }
}
