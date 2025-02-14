//
//  CardView.swift
//  YourNotes
//
//  Created by alexander on 2/12/24.
//

import SwiftUI

struct CardView: View {
    
    @EnvironmentObject var itemViewModel: ItemViewModel
    
    @State var item: ItemModel
//    let item: ItemModel
    @State var colorCard: Color = Color(#colorLiteral(red: 0.9787905452, green: 0.8980907015, blue: 0.6607496145, alpha: 1))
    @State var fontColor: Color = Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
    @State var showRemove: Bool = true
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
//                    .shadow(color: .gray, radius: 15)
                    .overlay(
                        VStack {
                        Text(item.title)
                            .foregroundColor(fontColor)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .leading)
                        Text(item.caption)
                            .padding(8)
                            .foregroundColor(fontColor)
                            .frame(width: UIScreen.main.bounds.width * 0.37, height: UIScreen.main.bounds.height * 0.12, alignment: .topLeading)
                        
                        HStack {
                            Spacer()
                                .frame(width: UIScreen.main.bounds.width * 0.25)
                            
                            ZStack {
                                    Circle()
                                        .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(item.flag ? .green : Color(#colorLiteral(red: 0.9240196943, green: 0.7460784316, blue: 0.6186274886, alpha: 1)))
                                    if item.flag {
                                        Image(systemName: "checkmark")
                                            .font(.headline)
                                    }
                            }
                            
                            Button(action: {
                                
                            }, label: {
//                                    ZStack {
//                                            Circle()
//                                                .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                                .foregroundColor(item.flag ? .green : Color(#colorLiteral(red: 0.9240196943, green: 0.7460784316, blue: 0.6186274886, alpha: 1)))
//                                            if item.flag {
//                                                Image(systemName: "checkmark")
//                                                    .font(.headline)
//                                            }
//                                    }
                        })
                        }
                    })
            
                    .contextMenu(menuItems: {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)){
                                itemViewModel.removeItem(at: itemViewModel.items.firstIndex(of: item) ?? 0)}
                            }, label: {
                                HStack {
                                    Text("Remove")
                                    Image(systemName: "trash")
                                }
                        })
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                item.flag.toggle()
                                itemViewModel.updateItem(item: item)
                            }
                            }, label: {
                                if item.flag {
                                    HStack {
                                        Text("Incomplete")
                                        Image(systemName: "xmark")
                                    }
                                } else {
                                    HStack {
                                        Text("Completed!")
                                        Image(systemName: "checkmark")
                                    }
                                }
                        })
                    })
            
            // overlay
            
                
            }
        .foregroundColor(colorCard)
    }
}

struct CardView_Previews: PreviewProvider {
    
    static var item1 = ItemModel(title: "First", caption: "First caption", flag: true)
    static var item2 = ItemModel(title: "Second", caption: "Second caption", flag: false)

    
    static var previews: some View {
        Group {
            CardView(item: item1)
            CardView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}
