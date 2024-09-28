//
//  FavoriteView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct FavoriteView: View {
    
    @EnvironmentObject private var webService: WebService
    
    @State private var shouldAnimate = false
    @State private var isShowAlert = false
    @State private var selectedRecipe: Recipe? = nil
    @Binding var tabSelection: Int
    
    let title = "Favorites"
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack{
                    if webService.favoriteArray.isEmpty {
                        ProgressView()
                            .padding()
                            .tint(.white)
                            .foregroundColor(.white)
                            .onChange(of: webService.favoriteDataEmpty, { oldValue, newValue in
                                isShowAlert = newValue
                                withAnimation {
                                    tabSelection = 1
                                }
                            })
                    } else {
                        List(webService.favoriteArray.sorted(by: { $0.name < $1.name }), id: \.id) { favorite in
                            
                            RecipeCellView(recipe: favorite)
                                .onTapGesture { selectedRecipe = favorite }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                                .listRowSeparator(.hidden)
                            
                        }
                        .navigationTitle(title)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
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
        }
        .task {
            do {
                webService.checkFavDataEmpty()
            }
        }
        .alert(isPresented: $isShowAlert) { Alert(title: Text("NO FAVORITES!!!"), message: Text("You have no favorite recipes"), dismissButton: .default(Text("OK")))}
    }
}

#Preview {
    FavoriteView(tabSelection: .constant(3))
}
