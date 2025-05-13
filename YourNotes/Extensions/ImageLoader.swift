//
//  ImageLoader.swift
//  YourNotes
//
//  Created by alexander on 8.04.25.
//

import SwiftUI
import PhotosUI

class ImageLoader {
        
    static func loadImages(from items: [PhotosPickerItem], completion: @escaping ([UIImage]) -> Void) {
            Task {
                var loadedImages: [UIImage] = []
    
                // Загружаем каждое изображение
                for item in items {
                    do {
                        if let data = try await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            loadedImages.append(uiImage)
                        }
                    } catch {
                        print("Error loading image: \(error)")
                    }
                }
                completion(loadedImages)
            }
        }

    static func imageFromData(data: [Data]?) -> [UIImage]? {
        guard let data = data else { return nil }
        return data.compactMap { UIImage(data: $0) }
    }
}


