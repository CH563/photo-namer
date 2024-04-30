//
//  DetailView.swift
//  PhotoNamer
//
//  Created by 陈立文 on 2024/4/26.
//

import SwiftUI
import MapKit

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.red)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DetailView: View {
    var photo: Photo
    var toDelete: (UUID) -> Void
    
    @Binding var path: NavigationPath
    
    @State private var isShowingDialog = false
    
    init(photo: Photo, path: Binding<NavigationPath>, toDelete: @escaping (UUID) -> Void) {
        self.photo = photo
        self.toDelete = toDelete
        self._path = path
    }
    
    var body: some View {
        VStack {
            VStack{
                ZStack(alignment: .bottomLeading) {
                    photo.image?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                    
                    Text(photo.name)
                        .font(.title)
                        .fontWeight(.black)
                        .padding(16)
                        .foregroundColor(.white)
                        .offset(x: -5, y: -5)
                        .shadow(radius: 5)
                }
            }
            .padding(.vertical)
            
            if let coordinate = photo.coordinate {
                VStack(alignment: .center) {
                    Text("Met")
                        .font(.headline)
                    
                    Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))))) {
                        Annotation(photo.name, coordinate: coordinate) {
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
                .padding()
            }
            Spacer()
            VStack {
                Button("Delete \(photo.name)", systemImage: "person.fill.badge.minus", role: .destructive) {
                    isShowingDialog = true
                }
                .buttonStyle(GrowingButton())
            }
            .padding()
        }
        .navigationBarTitle(photo.name, displayMode: .inline)
        .alert("Delete \(photo.name)", isPresented: $isShowingDialog) {
            Button("Delete", role: .destructive) {
                // Handle empty trash action.
                toDelete(photo.id)
                path = NavigationPath()
            }
            Button("Cancel", role: .cancel) {
                isShowingDialog = false
            }
        }
    }
}

#Preview {
    DetailView(photo: Photo.example, path: .constant(NavigationPath())) { _ in }
}
