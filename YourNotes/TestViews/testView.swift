//
//  testView.swift
//  YourNotes
//
//  Created by alexander on 2/12/24.
//

import SwiftUI

struct testView: View {
    
    @State var bckgColor: Color = Color.red
    @State var bckViewColor: Color = Color.orange
    @State var textFieldText: String = ""
    @State var textFieldTextCaption: String = "Enter text here"
    @State var sheetValue: Bool = false
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .background(bckgColor)
                .padding()
            
            ButtView(bckgColor: $bckgColor, textFieldText: $textFieldText, textFieldTextCaption: $textFieldTextCaption)
            
            Text(textFieldText)
            
            Button("Sheet") {
                sheetValue.toggle()
            }
            
        } .sheet(isPresented: $sheetValue, content: {
            ButtView(bckgColor: $bckgColor, textFieldText: $textFieldText, textFieldTextCaption: $textFieldTextCaption)
        })
    }
}

//struct ButtView: View {
//
//    @Binding var bckgColor: Color
//    @Binding var textFieldText: String
//    @Binding var textFieldTextCaption: String
//
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                bckgColor = Color.green
//            }, label: {
//                Text("Button")
//                    .foregroundColor(.red)
//        })
//            TextField(textFieldTextCaption, text: $textFieldText)
//
//        }
//    }
//}



struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}


