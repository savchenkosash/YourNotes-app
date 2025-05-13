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
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(note.title)
                        .frame(maxHeight: 20)
                        .font(.headline)
                    Spacer()
                    // Иконка завершения
                    Image(systemName: note.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(note.isCompleted ? .green : .gray)
                        .font(.title2)
                }
                
                Text(note.subTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let imagesData = note.noteImages, !imagesData.isEmpty {
                    
                    HStack(alignment: .center ,spacing: 8) {
                    // Если у нас одно изображение, то делаем его больше
                        if note.noteImages?.count == 1 {
                            ForEach(imagesData, id: \.self) { data in
                                    if let image = UIImage(data: data) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                            .padding(8)
                                }
                            }
                        } else {
                            // Если несколько
                            ForEach(Array(imagesData.prefix(2)), id: \.self) { data in
                                if let image = UIImage(data: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 50, alignment: .center)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        
                        // Добавляем "+n", если изображений больше двух
                        if imagesData.count > 2 {
                            VStack {
                                let extraCount = imagesData.count - 2
                                    Text("+\(extraCount)")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                        .frame(width: 20, height: 20)
                            }
                        }
                    }
                    .padding(8)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.22, alignment: .center)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.tertiarySystemBackground)))
        // Меню долгого нажатия
        .contextMenu(menuItems: {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)){
                    showAlert.toggle()
                }
            }, label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            })
            Button(action: {
                withAnimation(.spring()) {
                    // Переключаем статус завершенности
                    note.isCompleted.toggle()
                }
            }, label: {
                HStack {
                    if note.isCompleted {
                        HStack {
                            Text("Not done")
                            Image(systemName: "xmark")
                        }
                    } else {
                        HStack {
                            Text("Done!")
                            Image(systemName: "checkmark")
                        }
                    }
                }
            })
        })
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    private func getAlert() -> Alert {
        return Alert(title: Text(""),
                     message: Text("Are you sure you want to delete the note?"),
                     primaryButton: .default(Text("Cancel")),
                     secondaryButton: .destructive(Text("Delete"), action: {
                        withAnimation(.easeInOut(duration: 0.2)){
                            onDelete(note.noteID)
                        }
                }))
    }
}

#Preview {
    let mockNote = MockDataManager.shared.mockNote()
    
    // Моковые изображения для теста
    let imageData = [UIImage(named: "sampleImage2")?.jpegData(compressionQuality: 0.8),
                     UIImage(named: "sampleImage1")?.jpegData(compressionQuality: 0.8),
                     UIImage(named: "sampleImage2")?.jpegData(compressionQuality: 0.8)].compactMap { $0 }
    mockNote.noteImages = imageData
    
    return NoteCardView(note: mockNote, onDelete: { noteID in
        print("Удаление заметки с ID: \(noteID) в превью")
    })
    .padding()
}
