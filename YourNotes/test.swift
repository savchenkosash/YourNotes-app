////
////  PhotoPickerBootcamp.swift
////  SwiftConcurrencyBootcamp
////
////  Created by Nick Sarno on 5/20/23.
////
//
//import SwiftUI
//import PhotosUI
//
//@MainActor
//final class PhotoPickerViewModel: ObservableObject {
//    
////    @Published private(set) var selectedImages: [UIImage] = []
////    @Published var imageSelections: [PhotosPickerItem] = [] {
////        didSet {
////            setImages(from: imageSelections)
////        }
////    }
//    
////    private func setImages(from selections: [PhotosPickerItem]) {
////        Task {
////            var images: [UIImage] = []
////            for selection in selections {
////                if let data = try? await selection.loadTransferable(type: Data.self) {
////                    if let uiImage = UIImage(data: data) {
////                        images.append(uiImage)
////                    }
////                }
////            }
////            
////            selectedImages = images
////        }
////    }
//}
//
//struct PhotoPickerBootcamp: View {
//    
//    @StateObject private var viewModel = PhotoPickerViewModel()
//    
//    @State private(set) var selectedImages: [UIImage] = []
//    @State var imageSelections: [PhotosPickerItem] = [] {
//        didSet {
//            setImages(from: imageSelections)
//        }
//    }
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            Text("Hello, World!")
//            
//            if !selectedImages.isEmpty {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(selectedImages, id: \.self) { image in
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 50, height: 50)
//                                .cornerRadius(10)
//                        }
//                    }
//                }
//            }
//            
//            PhotosPicker(selection: $imageSelections, matching: .images) {
//                Text("Open the photos picker!")
//                    .foregroundColor(.red)
//            }
//        }
//    }
//    
//    private func setImages(from selections: [PhotosPickerItem]) {
//        Task {
//            var images: [UIImage] = []
//            for selection in selections {
//                if let data = try? await selection.loadTransferable(type: Data.self) {
//                    if let uiImage = UIImage(data: data) {
//                        images.append(uiImage)
//                    }
//                }
//            }
//            
//            selectedImages = images
//        }
//    }
//    
//}
//
//struct PhotoPickerBootcamp_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoPickerBootcamp()
//    }
//}


import SwiftUI
import PhotosUI

import SwiftUI
import PhotosUI

struct ContentV: View {
    // Массив для хранения выбранных изображений
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    var body: some View {
        VStack {
            // Кнопка для выбора нескольких изображений
            PhotosPicker(
                selection: $selectedItems, // Связываем с выбранными элементами
                maxSelectionCount: 5, matching: .images, // Разрешаем выбирать только изображения
                photoLibrary: .shared()) { // Максимум 5 изображений можно выбрать
                    Text("Выбрать изображения") // Текст кнопки
                }
                .onChange(of: selectedItems, perform: handleSelectionChange)

            // Если изображения выбраны, отображаем их
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }

    /// Обработчик изменения выбранных изображений
    private func handleSelectionChange(newItems: [PhotosPickerItem]) {
        // Загружаем все выбранные изображения
        loadImages(from: newItems) { images in
            selectedImages = images // Обновляем массив с изображениями
        }
    }

    /// Загрузка изображений из выбранных элементов
    private func loadImages(from items: [PhotosPickerItem], completion: @escaping ([UIImage]) -> Void) {
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

            // Передаем все загруженные изображения
            completion(loadedImages)
        }
    }
}


//@main
//struct PhotoPickerApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentV()
//        }
//    }
//}

struct PhotoPickerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ContentV()
    }
}
