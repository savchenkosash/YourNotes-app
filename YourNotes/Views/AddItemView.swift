//
//  AddItemView.swift
//  YourNotes
//
//  Created by alexander on 2/8/24.
//

import SwiftUI

struct AddItemView: View {
    
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var itemViewModel: ItemViewModel
    
    @State var textFieldText: String = ""
    @State var captionFieldText: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                    Text("Enter note name:")
                        .font(.title2)
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding()
                    TextField("Enter title here...", text: $textFieldText)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    TextEditor(text: $captionFieldText)
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                        .colorMultiply(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        }
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Add note")
                    .font(.body)
                    .fontWeight(.medium)
                    .padding(20)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }) .padding()
            
        } .alert(isPresented: $showAlert, content: getAlert)
        
        .navigationBarTitle("Add new note 🖍")
        .padding(.horizontal)
        
    }
    
    func saveButtonPressed() {
        if textIsAprioritate() {
            itemViewModel.addItem(title: textFieldText, caption: captionFieldText, flag: false)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func textIsAprioritate() -> Bool {
        if textFieldText.count < 3 || captionFieldText.count < 3 {
            alertTitle = "You need more than 3 symbols!"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddItemView()
        }
        .environmentObject(ItemViewModel())
    }
}
