//
//  Home.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftUI
import SwiftData

struct Home: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    @State private var isAddingNote = false
    @State private var selectedNote: Note? 
    
    private var navigationBarHidden: Bool {
        noteViewModel.allNotes.isEmpty ? true : false
    }
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.4, maximum: 300))]
    
    var body: some View {
        NavigationStack {
            VStack {
                if noteViewModel.allNotes.isEmpty {
                    Text("No notes. Add a new one! 📝")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        
                    Button {
                        isAddingNote.toggle()
                    } label: {
                        Text("Create a note!")
                            .font(.body)
                            .fontWeight(.bold)
                            .padding(20)
                            .frame(height: 55)
                            .background(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                } else {
                    ZStack (alignment: .bottom) {
                        VStack {
//                            // 🔍 Панель поиска (пока не функциональная)
//                            TextField("Поиск", text: .constant(""))
//                                .padding(10)
//                                .background(Color(.systemGray5))
//                                .cornerRadius(10)
//                                .padding(.horizontal)

                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(noteViewModel.allNotes, id: \.noteID) { note in
                                        NoteCardView(note: note) { noteID in
                                            noteViewModel.deleteNote(by: noteID)
                                        }
                                        .onTapGesture {
                                            selectedNote = note
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .background(Color(.systemGray6))
                        
            // Custom BottomBar
                        
                        if !navigationBarHidden {
                            HStack {
                                Spacer()
                                Button {
                                    isAddingNote.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 26))
                                            .fontWeight(.bold)
                                        Text("Note")
                                            .fontWeight(.medium)
                                            .font(.system(size: 18))
                                    }
                                    .padding()
                                }
                            }
                            .padding(.vertical, 3)
                            .padding(.bottom, 5)
                            .background(.ultraThinMaterial)
                            .ignoresSafeArea(edges: .bottom)
                        }
                    }
                }
            }
            .navigationTitle("All notes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(navigationBarHidden)
            .sheet(item: $selectedNote) { note in
                EditNoteView(note: note)
            }
            .sheet(isPresented: $isAddingNote) {
                CreateNoteView()
            }
            .onAppear {
                noteViewModel.loadAllNotes()
            }
        }
    }
}

#Preview("English") {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)

    return Home()
        .environmentObject(mockViewModel)
        .environment(\.locale, Locale(identifier: "en"))
}

#Preview("Russian") {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)

    return Home()
        .environmentObject(mockViewModel)
        .environment(\.locale, Locale(identifier: "ru"))
}
