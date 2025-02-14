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

    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _subTitle = State(initialValue: note.subTitle)
        _isCompleted = State(initialValue: note.isCompleted)
    }
    
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
                            .frame(width: 331 ,height: 150)
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
            }
            .navigationBarTitle("Изменить заметку", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Удалить") {
                    noteViewModel.deleteNote(by: note.noteID)
                    dismiss()
                } .foregroundColor(.red),
                trailing: Button("Сохранить") {
                    noteViewModel.note = note
//                    noteViewModel.updateNote(title: title, subTitle: subTitle, isCompleted: isCompleted)
                    saveNote()
                }
                .fontWeight(.bold)
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func saveNote() {
//        let imageData = noteImage?.jpegData(compressionQuality: 0.8)
        noteViewModel.updateNote(title: title, subTitle: subTitle, isCompleted: isCompleted
//        imageData: imageData
        )
        dismiss()
    }
    
}

#Preview {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)
    let mockNote = MockDataManager.shared.mockNote()

    return EditNoteView(note: mockNote)
    .environmentObject(mockViewModel)
}

