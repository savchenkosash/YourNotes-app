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
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var noteImage: UIImage?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Введите заголовок", text: $title)
                    ZStack (alignment: .topLeading) {
                        if subTitle.isEmpty {
                            Text("Введите описание")
                                .foregroundColor(.init(uiColor: .systemGray3))
                                .padding(.top, 13)
                                .padding(.horizontal, 8)
                        }
                        TextEditor(text: $subTitle)
                            .frame(width: 331 ,height: 140)
                            .padding(4)
                    }
                }
                
                Section(header: Text("Изменить статус")) {
                    Button(action: {
                        isCompleted.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isCompleted ? .green : .gray)
                                .font(.system(size: 24))
                            Text("Выполнено!")
                                
                                .foregroundColor(.primary)
                        }
                    })
                }
                
                Section {
                    if let image = noteImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button(action: {
                                noteImage = nil
                                selectedPhoto = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .background(Circle().fill(Color.white))
                            }
                            .padding(8)
                        }
                    }
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Label(selectedPhoto == nil ? "Выбрать изображение" : "Заменить изображение", systemImage: "photo")
                    }
                }
//                Section(header: Text("Изображение")) {
//                    
//                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
//                        Label(selectedPhoto == nil ? "Выбрать изображение" : "Заменить изображение", systemImage: "photo")
//                    }
//                    
//                    if let image = noteImage {
//                        ZStack(alignment: .topTrailing) {
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 200)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                            
//                            Button(action: {
//                                noteImage = nil
//                                selectedPhoto = nil
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                                    .background(Circle().fill(Color.white))
//                            }
//                            .padding(8)
//                        }
//                    } else {
//                        Text("Нет изображения")
//                            .foregroundColor(.gray)
//                    }
//                    
//                    
//                    
//                }
            }
            .navigationBarTitle("Новая заметка", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Отменить") {
                    dismiss()
                },
                trailing: Button("Создать") {
                    saveNote()
                }
                .fontWeight(.bold)
                .disabled(subTitle.isEmpty)
            )
        }
        .onChange(of: selectedPhoto) { _ in
            ImageLoader.loadImage(from: selectedPhoto) { image in
                self.noteImage = image
            }
        }
    }
    
    private func saveNote() {
        let imageData = noteImage?.jpegData(compressionQuality: 0.8)
        noteViewModel.createNote(title: title, subTitle: subTitle, imageData: imageData, isCompleted: isCompleted)
        dismiss()
    }
}

#Preview {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)

    return CreateNoteView()
        .environmentObject(mockViewModel)
}
