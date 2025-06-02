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
    
    @State private var selectedImagesFM: [PhotosPickerItem] = []
    @State private var noteImagesFM: [UIImage] = []
    @State private var noteImagePaths: [String] = [] // хранит пути к изображениям из FM
    
    
    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _subTitle = State(initialValue: note.subTitle)
        _isCompleted = State(initialValue: note.isCompleted)
//        _noteImagesFM = State(initialValue: [])
        
        // Загружаем изображения, если они есть
        if let imageDataArray = note.noteImages {
            _noteImages = State(initialValue: imageDataArray.compactMap { UIImage(data: $0) })
        }
        
        var imagesFromPaths: [UIImage] = []
        for path in note.noteImagePaths {
            if let image = ImageFileManager.loadImage(filename: path) {
                imagesFromPaths.append(image)
            }
        }
        _noteImagesFM = State(initialValue: imagesFromPaths)
        _noteImagePaths = State(initialValue: note.noteImagePaths)
        
//        if let paths = note.noteImagePaths {
//            var imagesFromPaths: [UIImage] = []
//            for path in paths {
//                if let image = ImageFileManager.loadImage(filename: path) {
//                    imagesFromPaths.append(image)
//                }
//            }
//            _noteImagesFM = State(initialValue: imagesFromPaths)
//            _noteImagePaths = State(initialValue: paths)
//        }
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
//                                            if let index = noteImagesFM.firstIndex(of: image) {
//                                                noteImagesFM.remove(at: index)
//                                            }
                                            // Сначала удаляем файл с диска
                                            let filename = noteImagePaths[index]
                                            ImageFileManager.deleteImage(filename: filename)
                                            
                                            // Удаляем из массива путей и изображений
                                            noteImagePaths.remove(at: index)
                                            noteImagesFM.remove(at: index)
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
                                    noteImagePaths = (noteImagePaths ?? []) + newPaths
                                    noteImagesFM.append(contentsOf: images)
                                }
                            }
                        }
                    }
                    
                    

                    
                            VStack(spacing: 20) {
                                Text("Удалить все сохранённые изображения")
                                    .font(.headline)
                                
                                Button(action: {
                                    deleteAllImagesFromDocuments()
                                }) {
                                    Text("Очистить изображения")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                }
            }
            .navigationBarTitle("Edit note", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Delete") {
                    showAlert.toggle()
                } .foregroundColor(.red),
                trailing: Button("Save") {
                    noteViewModel.note = note
                    noteViewModel.updateNote(title: title, subTitle: subTitle, isCompleted: isCompleted, noteImagePaths: noteImagePaths)
                    saveNote()
                }
                .fontWeight(.bold)
                .disabled(subTitle.isEmpty)
            )
        }
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func deleteAllImagesFromDocuments() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for fileURL in files {
                let ext = fileURL.pathExtension.lowercased()
                if ext == "jpg" || ext == "jpeg" || ext == "png" {
                    do {
                        try fileManager.removeItem(at: fileURL)
                        print("Удалён файл: \(fileURL.lastPathComponent)")
                    } catch {
                        print("Ошибка удаления файла \(fileURL.lastPathComponent): \(error.localizedDescription)")
                    }
                }
            }
            print("✅ Все изображения из Documents удалены.")
        } catch {
            print("Ошибка чтения содержимого папки Documents: \(error.localizedDescription)")
        }
    }
    
    private func saveNote() {
        let imageDataArray = noteImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        noteViewModel.updateNote(title: title, subTitle: subTitle, imagesData: imageDataArray, isCompleted: isCompleted, noteImagePaths: noteImagePaths)
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


