//
//  DogBreedImageGalleryView.swift
//  DogAPIDemo
//
//  Created by Nitesh Patel on 21/08/2024.
//

import SwiftUI

struct DogBreedImageGalleryView: View {
    var breedImages: [BreedImage]
    @Binding var currentImage: String
    let selectedImage: BreedImage

    var body: some View {
        VStack {
            galleryContent
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentImage = selectedImage.id
            }
        }
    }

    @ViewBuilder
    private var galleryContent: some View {
        if breedImages.isEmpty {
            emptyStateView
        } else {
            imageGalleryView
        }
    }

    @ViewBuilder
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "dog")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.gray)
            Text("No images available")
                .foregroundColor(.secondary)
                .padding()
        }
    }

    @ViewBuilder
    private var imageGalleryView: some View {
        TabView(selection: $currentImage) {
            ForEach(breedImages, id: \.self) { breedImage in
                AsyncImage(url: URL(string: breedImage.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .id(breedImage.id)
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                        .background(Color.gray.opacity(0.2))
                }
                .padding()
                .tag(breedImage.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            ThumbnailScrollView(breedImages: breedImages, currentImage: $currentImage)
        }
    }
}


struct ThumbnailScrollView: View {
    let breedImages: [BreedImage]
    @Binding var currentImage: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(breedImages) { breedImage in
                        ThumbnailView(
                            breedImage: breedImage,
                            isSelected: currentImage == breedImage.id
                        ) {
                            withAnimation {
                                currentImage = breedImage.id
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.opacity(0.80)).ignoresSafeArea()
            .onChange(of: currentImage) { oldValue, newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .bottom)
                }
            }
        }
    }
}

struct ThumbnailView: View {
    let breedImage: BreedImage
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        AsyncImage(url: URL(string: breedImage.imageUrl)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.white, lineWidth: 2)
                        .opacity(isSelected ? 1 : 0)
                }
                .onTapGesture {
                    onTap()
                }
        } placeholder: {
            Color.gray
                .frame(width: 60, height: 60)
                .cornerRadius(12)
        }
    }
}
