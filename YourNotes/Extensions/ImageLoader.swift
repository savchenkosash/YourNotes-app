//
//  ImageLoader.swift
//  YourNotes
//
//  Created by alexander on 8.04.25.
//

import SwiftUI
import PhotosUI

class ImageLoader {
    static func loadImage(from selectedPhoto: PhotosPickerItem?, completion: @escaping (UIImage?) -> Void) {
        guard let selectedPhoto else {
            completion(nil)
            return
        }
        
        Task {
            if let data = try? await selectedPhoto.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(uiImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    static func imageFromData(data: Data?) -> UIImage? {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }
    
//    static func clearImage(completion: @escaping () -> Void) {
//        DispatchQueue.main.async {
//            completion()
//        }
//    }
    
}

