//
//  CreateNoteView.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftUI
import PhotosUI

struct CreateNoteView: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var isCompleted: Bool = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var noteImages: [UIImage] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter a title", text: $title)
                    ZStack (alignment: .topLeading) {
                        if subTitle.isEmpty {
                            Text("Enter a description")
                                .foregroundColor(.init(uiColor: .systemGray3))
                                .padding(.top, 13)
                                .padding(.horizontal, 8)
                        }
                        TextEditor(text: $subTitle)
                            .frame(width: 331 ,height: 140)
                            .padding(4)
                    }
                }
                
                Section(header: Text("Change status")) {
                    Button(action: {
                        isCompleted.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isCompleted ? .green : .gray)
                                .font(.system(size: 24))
                            Text("Done!")
                                .foregroundColor(.primary)
                        }
                    })
                }
                
                Section(header: Text("Images")) {
                    
                    
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(noteImages, id: \.self) { image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))

                                        // Кнопка для удаления изображения
                                        Button(action: {
                                            if let index = noteImages.firstIndex(of: image) {
                                                noteImages.remove(at: index) // Удаляем изображение из массива
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.black.opacity(0.5)))
                                        }
                                        .padding(8)
                                    }
                                }
                            }
                        }
                    }

                    PhotosPicker(selection: $selectedImages, matching: .images, photoLibrary: .shared()) {
                        Label(selectedImages.isEmpty ? "Select image" : "Replace image", systemImage: "photo")
                    }
                    .onChange(of: selectedImages) { newItems in
                        ImageLoader.loadImages(from: newItems) { images in
                            noteImages = images
                        }
                    }
                }
            }
            .navigationBarTitle("New note", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Create") {
                    saveNote()
                }
                .fontWeight(.bold)
                .disabled(subTitle.isEmpty)
            )
        }
        /*
//        .onChange(of: selectedImages) { newImages in
//            ImageLoader.loadImages(from: newImages) { images in
//                self.noteImages.append(contentsOf: images.compactMap { $0 })
//            }
//        }
        
//        .onChange(of: selectedImages) { newItem in
//            Task {
//                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                   let uiImage = UIImage(data: data) {
//                    selectedImages = [uiImage] // Добавляем в массив
//                }
//            }
//        }
//        .onChange(of: selectedImages) { newImages in
//            ImageLoader.loadImages(from: newImages) { images in
//                self.noteImages.append(contentsOf: images.compactMap { $0 })
//            }
//        }
        */
    }
    
    /*
//    private func setImages(newItems: [PhotosPickerItem]) {
//        // Загружаем все выбранные изображения
//        loadImages(from: newItems) { images in
//            noteImages = images // Обновляем массив с изображениями
//        }
//    }
//    
//    private func loadImages(from items: [PhotosPickerItem], completion: @escaping ([UIImage]) -> Void) {
//        Task {
//            var loadedImages: [UIImage] = []
//
//            // Загружаем каждое изображение
//            for item in items {
//                do {
//                    if let data = try await item.loadTransferable(type: Data.self),
//                       let uiImage = UIImage(data: data) {
//                        loadedImages.append(uiImage)
//                    }
//                } catch {
//                    print("Error loading image: \(error)")
//                }
//            }
//            // Передаем все загруженные изображения
//            completion(loadedImages)
//        }
//    }
    */
    
//    private func setImagesByNick(from selections: [PhotosPickerItem]) {
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
//            noteImages = images
//        }
//    }
    
    private func saveNote() {
        let imageData = noteImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        noteViewModel.createNote(title: title, subTitle: subTitle, imagesData: imageData, isCompleted: isCompleted)
        dismiss()
    }
}

#Preview {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)

    return CreateNoteView()
        .environmentObject(mockViewModel)
}
