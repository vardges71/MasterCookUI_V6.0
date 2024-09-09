//
//  FavoritesListView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct FavoritesListView: View {
    
    @EnvironmentObject private var webServices: WebService
    
    @State private var shouldAnimate = false
    @State private var isShowAlert = false
    @State private var selectedRecipe: Recipe? = nil
    
    @Binding var tabSelected: Int
    
    var body: some View {
        VStack {
            
            if webServices.favoriteArray.isEmpty {
                
                ZStack {
                    ProgressView()
                        .padding()
                        .tint(.white)
                        .foregroundColor(.white)
                        .onChange(of: webServices.favoriteDataEmpty, { oldValue, newValue in
                            isShowAlert = newValue
                            withAnimation {
                                tabSelected = 1
                            }
                        })
                }
            } else {
                
                List(webServices.favoriteArray, id: \.id) { favorite in
                    
                    ZStack(alignment: .leading) {
                        
                        RecipeCellView(recipe: favorite)
                            .onTapGesture { selectedRecipe = favorite }
                    }
                    .animation(.default, value: true)
                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                    .listRowBackground(Color.clear)
                    
                } //: LIST
                .sheet(item: $selectedRecipe,
                       onDismiss: { self.selectedRecipe = nil }) { favorite in
                    SingleRecipeView(selectedRecipe: favorite)
                }
                       .scrollContentBackground(.hidden)
            }
        } //: VStack
        .task {
            webServices.favoriteArray.removeAll()
            DispatchQueue.main.async {
                webServices.checkFavDataEmpty()
            }
        }
        .alert(isPresented: $isShowAlert) { Alert(title: Text("NO FAVORITES!!!"), message: Text("You have no favorite recipes"), dismissButton: .default(Text("OK")))}
    }
}

#Preview {
    FavoritesListView(tabSelected: .constant(3))
}
