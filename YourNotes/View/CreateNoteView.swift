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
    
    @State private var selectedImagesFM: [PhotosPickerItem] = []
    @State private var noteImagesFM: [UIImage] = []
    @State private var noteImagePaths: [String] = []  // хранит пути к изображениям из FM

    
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
                    
                    if !noteImages.isEmpty {
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
                                                noteImages.remove(at: index)
//                                                selectedImages.remove(at: index)
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
                                print("IMAGE LOADED - onchange")
                            }
                            print("Call method onchange in success!")
                        }
                }
                
                Section(header: Text("FM Images")) {
                    
                    if !noteImagesFM.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(noteImagesFM.enumerated()), id: \.element) { index, image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))

                                        // Кнопка для удаления изображения - need fix
                                        Button(action: {
                                            // Сначала удаляем файл с диска
                                            let filename = noteImagePaths[index]
                                            ImageFileManager.deleteImage(filename: filename)
                                            
                                            // Удаляем из массива путей и изображений
                                            noteImagePaths.remove(at: index)
                                            noteImagesFM.remove(at: index)
                                            
//                                            if let index = noteImagesFM.firstIndex(of: image) {
//                                                noteImagesFM.remove(at: index)
//                                            }

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

                    PhotosPicker(selection: $selectedImagesFM, matching: .images, photoLibrary: .shared()) {
                        Label(selectedImagesFM.isEmpty ? "Select image FM" : "Replace image FM", systemImage: "photo")
                    }
                        .onChange(of: selectedImagesFM) {
                            
                            // old code
                            
//                            newItems in
//                            ImageLoaderFM.loadImages(from: newItems) { images in
//                                noteImagesFM = images
//                            }
                            
                             newItems in
                                                ImageLoaderFM.loadImages(from: newItems) { images in
                                                    // Здесь для каждого UIImage сохраняем в файловую систему и добавляем путь в noteImagePaths
                                                    DispatchQueue.global(qos: .userInitiated).async {
                                                        var newPaths: [String] = []
                                                        for image in images {
                                                            if let filename = ImageFileManager.saveImage(image, for: UUID()) {
                                                                newPaths.append(filename)
                                                            }
                                                        }
                                                        DispatchQueue.main.async {
                                                            // Добавляем новые пути и изображения
                                                            noteImagePaths.append(contentsOf: newPaths)
                                                            noteImagesFM.append(contentsOf: images)
                                                        }
                                                    }
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
    }
    
    private func saveNote() {
        let imageData = noteImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        noteViewModel.createNote(title: title, subTitle: subTitle, noteImagePaths: noteImagePaths)
        dismiss()
    }
}

#Preview {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)

    return CreateNoteView()
        .environmentObject(mockViewModel)
}
