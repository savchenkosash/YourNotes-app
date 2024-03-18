//
//  EditItemView.swift
//  YourNotes
//
//  Created by alexander on 2/9/24.
//

import SwiftUI

struct EditItemView: View {
    
    @EnvironmentObject var itemViewModel: ItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var item: ItemModel

    var body: some View {
            
                ScrollView {
                    VStack (alignment: .leading) {

                        Spacer()
                            .frame(height: 20)
                        
                        Text("Edit your note 🖍")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding()
                        
                        TextField("Enter title here...", text: $item.title)
                            .padding(.horizontal)
                            .frame(height: 55)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        TextEditor(text: $item.caption)
                            .frame(height: UIScreen.main.bounds.height * 0.4)
                            .colorMultiply(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    
                        Button(action: {
                            itemViewModel.editItem(id: item.id, title: item.title, caption: item.caption)
                            itemViewModel.updateItem(item: item)
                            presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Save & close")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .padding(20)
                                    .frame(height: 55)
                                    .background(Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }) .padding()
                    
                    Button(action: {
                        itemViewModel.removeItem(at: itemViewModel.items.firstIndex(of: item) ?? 0)
                        presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Delete note")
                                .font(.body)
                                .fontWeight(.medium)
                                .padding(20)
                                .frame(height: 55)
                                .background(Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }) .padding()
                    }
                .padding(.horizontal)
            }
        }

struct EditItemView_Previews: PreviewProvider {

    static var item3 = ItemModel(title: "Title here", caption: "Caption text here", flag: false)
    
    static var previews: some View {
        EditItemView(item: item3)
            .environmentObject(ItemViewModel())
    }
}


