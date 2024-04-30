//
//  AddView.swift
//  PhotoNamer
//
//  Created by 陈立文 on 2024/4/25.
//

import SwiftUI
import PhotosUI
import MapKit

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Photo) -> Void
    
    let locationFetcher = LocationFetcher()
    
    @State private var addViewModel = AddViewModel()
    
    init(onSave: @escaping (Photo) -> Void) {
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $addViewModel.selectedItem) {
                        if let currentImage = addViewModel.currentImage {
                            Image(uiImage: currentImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            ContentUnavailableView("No Photo", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: addViewModel.selectedItem, loadImage)
                }
                
                if addViewModel.isShowName {
                    Section("Name") {
                        HStack(spacing: 20) {
                            TextField("First name", text: $addViewModel.firstName)
                            TextField("Last name", text: $addViewModel.lastName)
                        }
                    }
                    
                    if let location = locationFetcher.lastKnownLocation {
                        Section("Met") {
                            Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))))) {
                                Annotation(addViewModel.name, coordinate: location) {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .foregroundStyle(.blue)
                                        .padding(10)
                                        .frame(width: 40, height: 40)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .shadow(radius: 5)
                                }
                            }
                            .frame(height: 300)
                        }
                    }
                }
            }
            .navigationTitle("Add Photo")
            .toolbar {
                Button("Save") {
                    let newPhoto = Photo(id: addViewModel.id, firstName: addViewModel.firstName, lastName: addViewModel.lastName, latitude: locationFetcher.lastKnownLocation?.latitude, longitude: locationFetcher.lastKnownLocation?.longitude)
                    if let img = addViewModel.currentImage {
                        if let url = writeToSecureDirectory(uiImage: img, name: addViewModel.id.uuidString) {
                            print("save to: \(url)")
                        }
                    }
                    onSave(newPhoto)
                    dismiss()
                }
                .disabled(addViewModel.isDisabled)
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let selectedImage = try await addViewModel.selectedItem?.loadTransferable(type: Data.self) else {
                return
            }
            guard let inputImage = UIImage(data: selectedImage) else {
                return
            }
            addViewModel.currentImage = inputImage
            locationFetcher.start()
        }
    }
    
    func writeToSecureDirectory(uiImage: UIImage, name: String) -> URL? {
        if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
            let url = URL.documentsDirectory.appending(path: "\(name).jpg")
            try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            return url
            // What do we do about the save error?
        }
        return nil
    }
}

#Preview {
    AddView() { _ in }
}
