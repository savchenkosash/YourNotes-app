//
//  NoteViewModel.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftData
import Foundation
import SwiftUI

class NoteViewModel: ObservableObject {
    @Published var note: Note?
    @Published var allNotes: [Note] = []

    private let noteService: NoteServiceProtocol

    var service: NoteServiceProtocol { noteService }

    init(noteService: NoteServiceProtocol) {
        self.noteService = noteService
        loadAllNotes()
    }

    func loadNote(by id: String) {
        self.note = noteService.fetchNote(by: id)
    }

    func loadAllNotes() {
        self.allNotes = noteService.fetchAllNotes()
    }

    // 💾 Создание новой заметки
    func createNote(title: String, subTitle: String, imagesData: [Data]? = nil, isCompleted: Bool = false, noteImagePaths: [String]) {
        let newNote = Note(noteImages: imagesData, title: title, subTitle: subTitle, isCompleted: isCompleted, noteImagePaths: noteImagePaths)
        noteService.createNote(newNote)
        loadAllNotes()
        print("✅ Новая заметка создана.")
    }

    // ✏️ Обновление данных существующей заметки
    func updateNote(title: String, subTitle: String, imagesData: [Data]? = nil, isCompleted: Bool = false, noteImagePaths: [String]) {
        guard let note = note else { return }

        note.title = title
        note.subTitle = subTitle
        note.noteImages = imagesData
        note.isCompleted = isCompleted
        note.noteImagePaths = noteImagePaths

        noteService.updateNote(by: note.noteID, with: note)
        
        loadNote(by: note.noteID)
        loadAllNotes()
        print("✅ Заметка обновлена.")
    }

    // 🗑 Удаление заметки
    func deleteNote(by id: String) {
        noteService.deleteNote(by: id)
        loadAllNotes()
        print("✅ Заметка удалена.")
    }
}
