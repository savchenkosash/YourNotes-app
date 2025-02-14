//
//  MainView.swift
//  YourNotes
//
//  Created by alexander on 2/7/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var itemViewModel: ItemViewModel
    
    @State var showSheet: Bool = false
    @State var selectedItem: ItemModel? = nil
    @State var showRemove: Bool = false
    @State var showXicon: Bool = false
    @State var hideNavigationBar: Bool = false
    @State var showFavoritesItems: Bool = false
    

    let columns: [GridItem] = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.4, maximum: 300))]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if itemViewModel.items.isEmpty {
                    Text("Your notes list is empty!")
                        .font(.title2)
                        .foregroundColor(Color(UIColor.darkText))
                        .padding()
                    
                    NavigationLink(
                        destination: AddItemView(),
                        label: {
                            Text("Create first note!")
                                .font(.body)
                                .fontWeight(.medium)
                                .padding(20)
                                .frame(height: 55)
                                .background(Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        })
                } else {
                    
                    // Search bar
                    
                        HStack {
                            TextField("What I can find? Type something...", text: $itemViewModel.filterTextField)
                                .onChange(of: itemViewModel.filterTextField, perform: { value in
                                    itemViewModel.updateFilteredArray();
                                    searchBarChanged()
                                })
                                .onTapGesture { searchBarTapped() }
                                .padding()
                                .frame(height: 55)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .padding(.horizontal, 15)
                            
                            Button(action: { xButtonAction() },
                                   label: { if showXicon {
                                        ZStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                            }
                                        }
                                   })
                            
                            Button(action: { cancelBarButtonAction() },
                                   label: { if hideNavigationBar {
                                        Text("Cancel")
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 15)
                                           }
                                    })
                                }
                            .padding(.horizontal, 6)
                        
                    // Search bar END
                        
                    // No find results view
                    
                    if itemViewModel.filterTextField != "" && itemViewModel.filteredArray.isEmpty {
                        
                        VStack {
                            Text("No search results")
                                .font(.title)
                                .foregroundColor(Color(UIColor.systemGray3))
                                .padding()
                        }
                    
                    // No find results view END
                        
                    // Filter and no filter view
                        
                    } else {
                        LazyVGrid(columns: columns) {
                            if itemViewModel.filteredArray.isEmpty && !showFavoritesItems {
                                ForEach (itemViewModel.items, id: \.self) { item in
                                    ZStack {
                                        CardView (item: item)
                                                        .padding(.all, 10)
//                                                        .contextMenu(menuItems: {
//                                                            Button(action: {
//                                                                withAnimation(.easeInOut(duration: 0.2)){
//                                                                    itemViewModel.removeItem(at: itemViewModel.items.firstIndex(of: item) ?? 0)}
//                                                                }, label: {
//                                                                Text("Remove")
//                                                            })
//                                                        })
                                                        .sheet(item: $selectedItem,
                                                               onDismiss: {
                                                                selectedItem = nil
                                                                itemViewModel.disableFilter()
                                                               },
                                                               content: { model in
                                                                EditItemView(item: model)
                                                        })
                                                        .onTapGesture {
                                                                selectedItem = item
                                                    }
                                        
                                            // NEW FUNC (BETA)
                                        
//                                        if showRemove {
//                                            VStack(alignment: .trailing) {
//                                                                Button(action: {
//                                                                    itemViewModel.removeItem(at: itemViewModel.items.firstIndex(of: item) ?? 0)
//                                                                }, label: {
//                                                                    Text("⛔️")
//                                                                        .font(.largeTitle)
//                                                                        .frame(width: 35, height: 35, alignment: .topTrailing)
//                                                                        .shadow(radius: 10)
//                                                                })
//                                                                Spacer()
//                                                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.17, alignment: .center)
//                                            }
//                                        }
                                    }
                                }
                            } else {
                                if showFavoritesItems {
                                    ForEach (itemViewModel.favoritesArray, id: \.self) { item in
                                        ZStack {
                                            CardView (item: item)
                                                            .padding(.all, 10)
//                                                            .contextMenu(menuItems: {
//                                                                Button(action: {
//                                                                    withAnimation(.easeInOut(duration: 0.2)){
//                                                                        itemViewModel.removeItem(at: itemViewModel.items.firstIndex(of: item) ?? 0)
//                                                                        itemViewModel.updateFilteredArray()
//                                                                    }
//                                                                    }, label: {
//                                                                    Text("Remove!")
//                                                                })
//                                                            })
                                                            .onTapGesture {
                                                                    selectedItem = item
                                                                    itemViewModel.disableFilter()
                                                        }
                                        }
                                    }
                                } else {
                                    ForEach (itemViewModel.filteredArray, id: \.self) { item in
                                        ZStack {
                                            CardView (item: item)
                                                            .padding(.all, 10)
                                                            .contextMenu(menuItems: {
                                                                Button(action: {
                                                                    withAnimation(.easeInOut(duration: 0.2)){
                                                                        itemViewModel.removeItem(at: itemViewModel.items.firstIndex(of: item) ?? 0)
                                                                        itemViewModel.updateFilteredArray()
                                                                    }
                                                                    }, label: {
                                                                    Text("Remove")
                                                                })
                                                            })
                                                            .onTapGesture {
                                                                    selectedItem = item
                                                                    itemViewModel.disableFilter()
                                                        }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    // END Filter and no filter view END
                    
                        // old destination be here
                        
                    }
                }
            }
            .onTapGesture { scrollViewTapped() }
            .navigationBarHidden(hideNavigationBar)
            .navigationTitle(showFavoritesItems ? Text("Completed ✅") : Text("My notes 📝"))
            .navigationBarItems(trailing: NavigationLink("Add item", destination: AddItemView()))
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        showRemove.toggle()
////                        itemViewModel.items.removeAll()
//                    }, label: {
//                        Image(systemName: "gear")
//                    })
//                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu ("Options"){
                            Button("Sort A-Z"){
                                itemViewModel.updateFilteredArrayByName()
                            }
                            Button("Show completed"){
                                itemViewModel.updateFavoritesArray()
                                showFavoritesItems.toggle()
                            }
                            
                        }
                    }
                }
        }
    
        func searchBarChanged() {
            withAnimation(.easeInOut(duration: 0.2)){
                if itemViewModel.filterTextField != "" {
                    hideNavigationBar = true
                    showXicon = true
                }
//                                        else {
//                                            hideNavigationBar = false
//                                            showX = false
//                                        }
            }
        }
    
        func searchBarTapped() {
            withAnimation(.easeInOut(duration: 0.2)){
                showXicon = true
                hideNavigationBar = true
            }
        }
    
        func xButtonAction() {
            itemViewModel.filterTextField = ""
        }
    
        func cancelBarButtonAction() {
            hideNavigationBar = false
            showXicon = false
            itemViewModel.filterTextField = ""
        }
    
        func scrollViewTapped() {
            withAnimation(.easeOut(duration: 0.1)){
                itemViewModel.filterTextField = ""
                showXicon = false
                hideNavigationBar = false
            }
        }
    
    }

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
        } .environmentObject(ItemViewModel())
    }
    
}


