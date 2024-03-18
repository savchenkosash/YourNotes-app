//
//  ButtView.swift
//  YourNotes
//
//  Created by alexander on 2/13/24.
//

import SwiftUI

struct ButtView: View {

    @Binding var bckgColor: Color
    @Binding var textFieldText: String
    @Binding var textFieldTextCaption: String


    var body: some View {
        VStack {
            Button(action: {
                bckgColor = Color.green
            }, label: {
                Text("Button")
                    .foregroundColor(.red)
        })
            TextField(textFieldTextCaption, text: $textFieldText)

        }
    }
}


//struct ButtView_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtView(bckgColor: Color, textFieldText: "Hello", textFieldTextCaption: "Hello")
//    }
//}
