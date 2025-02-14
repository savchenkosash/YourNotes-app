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
    
    @State private var searchBarText: String = ""
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.4, maximum: 300))]
    
    var body: some View {
        NavigationStack {
            VStack {
                if noteViewModel.allNotes.isEmpty {
                    Text("Нет заметок. Добавьте новую! 📝")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        
                    Button {
                        isAddingNote.toggle()
                    } label: {
                        Text("Создать заметку!")
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
                        
                        HStack {
                            Spacer()
                            Button {
                                isAddingNote.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 26))
//                                        .font(.custom("Poppins-Bold", size: 26))
                                        .fontWeight(.bold)
                                    Text("Заметка")
                                        .fontWeight(.medium)
                                        .font(.system(size: 18))
                                }
                                .padding()
/*                                Label("Заметка", systemImage: "plus.circle.fill")
//                                    .fontWeight(.medium)
//                                    .font(.title3)
//                                    .foregroundColor(.blue)
//                                    .padding()
*/
                            }
                        }
                        .padding(.vertical, 3)
                        .padding(.bottom, 5)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea(edges: .bottom)
                    }
                }
            }
            .searchable(text: $searchBarText)
            .navigationTitle("Все заметки")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        isAddingNote.toggle()
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.title)
//                            .foregroundColor(.blue)
//                    }
//                }
//                
////                ToolbarItem(placement: .bottomBar) {
////                    Button(action: {
////                        // действие
////                    }) {
////                        HStack {
////                            Text("Новая заметка")
////                            Image(systemName: "plus.circle.fill")
////                                .fontWeight(.bold)
////                                .foregroundColor(.blue)
////                        }
////                    }
////                }
//            }
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

#Preview {
    let mockService = MockNoteService()
    let mockViewModel = NoteViewModel(noteService: mockService)

    return Home()
        .environmentObject(mockViewModel)
}
