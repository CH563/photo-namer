//
//  ContentView.swift
//  PhotoNamer
//
//  Created by 陈立文 on 2024/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var photoViewModel = PhotoViewModel()
    @State private var path = NavigationPath()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    ForEach(photoViewModel.lists.sorted()) { photo in
                        NavigationLink(value: photo) {
                            ZStack(alignment: .bottomLeading) {
                                photo.image?
                                    .resizable()
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 150)
                                    .cornerRadius(10)
                                Text(photo.name)
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .shadow(radius: 15)
                                    .offset(x: -5, y: -5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 15)
            .navigationTitle("Photo Namer")
            .navigationDestination(for: Photo.self) { photo in
                DetailView(photo: photo, path: $path) { id in
                    withAnimation(.easeOut(duration: 0.3)) {
                        photoViewModel.deletePhoto(id: id)
                    }
                }
            }
            .toolbar {
                Button("Add Photo", systemImage: "plus") {
                    photoViewModel.isShowAdd = true
                }
            }
            .sheet(isPresented: $photoViewModel.isShowAdd) {
                AddView() { photo in
                    withAnimation(.easeIn(duration: 0.3)) {
                        photoViewModel.addPhoto(newPhoto: photo)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
