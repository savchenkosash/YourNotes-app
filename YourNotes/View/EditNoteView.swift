import SwiftUI
import PhotosUI

struct EditNoteView: View {
    
    @EnvironmentObject var noteViewModel: NoteViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImages: [PhotosPickerItem] = [] // Список выбранных фотографий
    
    let note: Note
    @State private var title: String
    @State private var subTitle: String
    @State private var isCompleted: Bool
    @State private var noteImages: [UIImage] = [] // Массив изображений
    
    @State private var showAlert: Bool = false
    
    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _subTitle = State(initialValue: note.subTitle)
        _isCompleted = State(initialValue: note.isCompleted)
        
        // Загружаем изображения, если они есть
        if let imageDataArray = note.noteImages {
            _noteImages = State(initialValue: imageDataArray.compactMap { UIImage(data: $0) })
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
                
                Section(header: Text("Images")) {
 
                    if !noteImages.isEmpty {
                        // Проходим по всем изображениям в массиве noteImages
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
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    private func saveNote() {
        let imageDataArray = noteImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        noteViewModel.updateNote(title: title, subTitle: subTitle, imagesData: imageDataArray, isCompleted: isCompleted)
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


