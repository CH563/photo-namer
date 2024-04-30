//
//  AddViewModel.swift
//  PhotoNamer
//
//  Created by 陈立文 on 2024/4/25.
//

import Foundation
import SwiftUI
import PhotosUI

extension AddView {
    @Observable
    class AddViewModel {
        var id: UUID = UUID()
        var firstName: String
        var lastName: String
        var latitude: Double?
        var longitude: Double?
        var currentImage: UIImage?
        var selectedItem: PhotosPickerItem?
        
        var name: String {
            if firstName.isEmpty && lastName.isEmpty {
                return "Met at here"
            }
            return "\(firstName) \(lastName)"
        }
        
        
        var isShowName: Bool {
            currentImage != nil
        }
        
        var isDisabled: Bool {
            firstName.isEmpty || lastName.isEmpty
        }
        
        init(id: UUID = UUID(), firstName: String = "", lastName: String = "", latitude: Double? = nil, longitude: Double? = nil) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
