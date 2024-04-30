//
//  PhotoViewModel.swift
//  PhotoNamer
//
//  Created by 陈立文 on 2024/4/25.
//

import Foundation
import MapKit

extension ContentView {
    @Observable
    class PhotoViewModel {
        private(set) var lists: [Photo]
        var isShowAdd: Bool = false
        
        let savePath = URL.documentsDirectory.appending(path: "savedData")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                lists = try JSONDecoder().decode([Photo].self, from: data)
            } catch {
                lists = []
            }
        }
        
        func addPhoto(newPhoto: Photo) {
            lists.append(newPhoto)
            save()
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(lists)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func deletePhoto(id: UUID) {
            lists = lists.filter{ $0.id != id }
            save()
            let fileURL = URL.documentsDirectory.appending(path: "\(id).jpg")
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Image deleted successfully")
            } catch {
                print("Error deleting image: \(error)")
            }
        }
    }
}
