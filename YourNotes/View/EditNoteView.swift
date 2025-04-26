//
//  EditNoteView.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftUI
import PhotosUI

struct EditNoteView: View {
    
    @EnvironmentObject var noteViewModel: NoteViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    let note: Note
    @State private var title: String
    @State private var subTitle: String
    @State private var isCompleted: Bool
    @State private var noteImage: UIImage?
    
    @State private var showAlert: Bool = false

    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _subTitle = State(initialValue: note.subTitle)
        _isCompleted = State(initialValue: note.isCompleted)
        
        // Загружаем изображение, если оно есть
        if let imageData = note.noteImage, let image = UIImage(data: imageData) {
            _noteImage = State(initialValue: image)
        }
    }
    
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
                
                Section {
                    if let image = noteImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
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
                        Label(selectedPhoto == nil ? "Select image" : "Replace image", systemImage: "photo")
                    }
                }
            }
            .navigationBarTitle("Edit note", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Delete") {
                    showAlert.toggle()
                } .foregroundColor(.red),
                trailing: Button("Save") {
                    noteViewModel.note = note
                    noteViewModel.updateNote(title: title, subTitle: subTitle, isCompleted: isCompleted)
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
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    private func saveNote() {
        let imageData = noteImage?.jpegData(compressionQuality: 0.8)
        noteViewModel.updateNote(title: title, subTitle: subTitle, imageData: imageData, isCompleted: isCompleted)
        dismiss()
    }
    
    private func getAlert() -> Alert {
        return Alert(title: Text(""),
                     message: Text("Are you sure you want to delete the note?"),
                     primaryButton: .default(Text("Cancel")),
                     secondaryButton: .destructive(Text("Delete"), action: {
                    noteViewModel.deleteNote(by: note.noteID)
                    dismiss()
                }))
    }
    
}

#Preview {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)
    let mockNote = MockDataManager.shared.mockNote()

    return EditNoteView(note: mockNote)
    .environmentObject(mockViewModel)
}

