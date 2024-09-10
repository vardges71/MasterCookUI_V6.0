//
//  FavoritesListView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct FavoritesListView: View {
    
    @EnvironmentObject private var webService: WebService
    
    @State private var shouldAnimate = false
    @State private var isShowAlert = false
    @State private var selectedRecipe: Recipe? = nil
    
    @Binding var tabSelected: Int
    
    var body: some View {
        VStack {
            
            if webService.favoriteArray.isEmpty {
                
                ZStack {
                    ProgressView()
                        .padding()
                        .tint(.white)
                        .foregroundColor(.white)
                        .onChange(of: webService.favoriteDataEmpty, { oldValue, newValue in
                            isShowAlert = newValue
                            withAnimation {
                                tabSelected = 1
                            }
                        })
                }
            } else {
                
                List(webService.favoriteArray, id: \.id) { favorite in
                    
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
                        .overlay(
                            Button(action: {
                                self.selectedRecipe = nil
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 2, x: 2, y: 2)
                            }
                                .padding(.top, 10)
                                .padding(.trailing, 10)
                            , alignment: .topTrailing
                        )
                }
                       .scrollContentBackground(.hidden)
            }
        } //: VStack
        .task {
            webService.favoriteArray.removeAll()
            do {
                webService.checkFavDataEmpty()
            }
        }
        .alert(isPresented: $isShowAlert) { Alert(title: Text("NO FAVORITES!!!"), message: Text("You have no favorite recipes"), dismissButton: .default(Text("OK")))}
    }
}

#Preview {
    FavoritesListView(tabSelected: .constant(3))
}
