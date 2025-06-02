//
//  ImageLoaderFM.swift
//  YourNotes
//
//  Created by alexander on 19.05.25.
//

import SwiftUI
import PhotosUI

class ImageLoaderFM {
        
    // Функция для асинхронной загрузки изображений и сохранения их в файловую систему
    static func loadImages(from items: [PhotosPickerItem], completion: @escaping ([UIImage]) -> Void) {
        Task {
            // Массив для хранения асинхронных задач
            await withTaskGroup(of: UIImage?.self) { group in
                for item in items {
                    group.addTask {
                        do {
                            // Загружаем изображение в фоновом потоке
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                // Сохраняем изображение в файловую систему
                                if let filename = ImageFileManager.saveImage(uiImage, for: UUID()) {
                                    // Загружаем изображение из файловой системы и возвращаем
                                    return ImageFileManager.loadImage(filename: filename)
                                }
                            }
                        } catch {
                            print("Error loading image: \(error)")
                        }
                        return nil
                    }
                }

                // Массив для загруженных изображений
                var loadedImages: [UIImage] = []
                // Собираем все изображения, возвращенные из асинхронных задач
                for await image in group {
                    if let image = image {
                        loadedImages.append(image)
                    }
                }
                // Завершаем функцию после загрузки всех изображений
                completion(loadedImages)
            }
        }
    }

//
//    static func imageFromData(data: [Data]?) -> [UIImage]? {
//        guard let data = data else { return nil }
//        return data.compactMap { UIImage(data: $0) }
//    }
}

struct ImageFileManager {
    static func saveImage(_ image: UIImage, for noteID: UUID) -> String? {
        let filename = "\(noteID)-\(UUID().uuidString).jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: url)
            return filename
        }
        return nil
    }

    static func loadImage(filename: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    static func deleteImage(filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: url)
            print("Изображение успешно удалено: \(filename)")
        } catch {
            print("Ошибка удаления изображения: \(error.localizedDescription)")
        }
    }


    static private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
