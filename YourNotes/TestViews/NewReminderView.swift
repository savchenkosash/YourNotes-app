//
//  NewReminderView.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftUI

struct NewReminderScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Поля ввода
                VStack(spacing: 8) {
                    TextField("По названию", text: $title)
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.separator), lineWidth: 0.5)
                        )
                    
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.separator), lineWidth: 0.5)
                        )
                        .overlay(
                            // Placeholder для TextEditor
                            Group {
                                if notes.isEmpty {
                                    Text("Заметки")
                                        .foregroundColor(Color(UIColor.placeholderText))
                                        .padding(12)
                                        .allowsHitTesting(false)
                                }
                            }
                        )
                }
                .padding(.horizontal)
                
                // Секция с деталями
                List {
                    NavigationLink(destination: Text("Дата и время")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Подробнее")
                                Text("Завтра")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    NavigationLink(destination: Text("Выбор списка")) {
                        HStack {
                            Label("Список", systemImage: "list.bullet")
                                .labelStyle(TitleOnlyLabelStyle())
                            Spacer()
                            Text("Напоминания")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Spacer()
            }
            .navigationBarTitle("Новое напоминание", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Отменить") {
                    dismiss()
                },
                trailing: Button("Добавить") {
                    // Сохранение
                }
                .disabled(title.isEmpty)
            )
        }
    }
}


struct NewReminderScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewReminderScreen()
    }
}
