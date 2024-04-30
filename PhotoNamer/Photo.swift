//
//  Photo.swift
//  PhotoNamer
//
//  Created by 陈立文 on 2024/4/25.
//


import Foundation
import MapKit
import SwiftUI

struct Photo: Codable, Comparable, Identifiable, Hashable {
    var id: UUID
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var image: Image? {
        let url = URL.documentsDirectory.appending(path: "\(id).jpg")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        guard let uiImage = try? UIImage(data: Data(contentsOf: url)) else {
            print("Error creating UIImage from url \(url)")
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
    
    #if DEBUG
    static let example = Photo(id: UUID(), firstName: "Tom", lastName: "Lee")
    #endif
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func <(lhs: Photo, rhs: Photo) -> Bool {
        lhs.name.lowercased() < rhs.name.lowercased()
    }
}
