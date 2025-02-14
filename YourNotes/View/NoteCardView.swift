//
//  NoteCardView.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftUI

struct NoteCardView: View {
    
    let note: Note
    let onDelete: (String) -> Void
    
    //    @EnvironmentObject var noteViewModel: NoteViewModel
    //    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(note.title)
                        .frame(maxHeight: 20)
                        .font(.headline)
                    Spacer()
                    // 🏁 Иконка завершения
                    Image(systemName: note.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(note.isCompleted ? .green : .gray)
                        .font(.title2)
                }
                
                Text(note.subTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Image loader img
                /* Img
                 
                                 if let image = ImageLoader.imageFromData(data: note.noteImage ?? Data()) {
                 
                                         Image(uiImage: image)
                                             .resizable()
                                             .scaledToFit()
                 //                            .frame(height: 200)
                                             .clipShape(RoundedRectangle(cornerRadius: 10))
                                         .padding(8)
                                 }
                 
                 */
                
//                Button {
//                    onDelete(note.noteID)
//                } label: {
//                    Image(systemName: "trash.fill")
//                        .foregroundColor(.red)
//                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.22, alignment: .center)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.tertiarySystemBackground)))
        .contextMenu(menuItems: {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)){
                    onDelete(note.noteID)
//                    noteViewModel.deleteNote(by: note.noteID)
//                    dismiss()
                }
                }, label: {
                    HStack {
                        Text("Удалить")
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
            })
            Button(action: {
                withAnimation(.spring()) {
                    note.isCompleted.toggle()
                    }
                }, label: {
                        HStack {
                            if note.isCompleted {
                                HStack {
                                    Text("Не выполнено")
                                    Image(systemName: "xmark")
                                }
                            } else {
                                HStack {
                                    Text("Выполнено!")
                                    Image(systemName: "checkmark")
                                }
                            }
                    }
            })
        })
    }
}

#Preview {
    let mockNote = MockDataManager.shared.mockNote()

    return NoteCardView(note: mockNote, onDelete: { noteID in
        print("Удаление заметки с ID: \(noteID) в превью")
    })
    .padding()
}
