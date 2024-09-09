//
//  ContentView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-07-08.
//

import SwiftUI

struct SearchResultView: View {
    
    @EnvironmentObject private var webService: WebService
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    @State private var selectedRecipe: Recipe? = nil
    @Binding var tabSelection: Int
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack {
                    if webService.recipeData?.results.count == 0 {
                        ProgressView()
                    } else {
                        List(webService.recipeData?.results ?? [], id: \.id) { recipe in
                            
                            RecipeCellView(recipe: recipe)
                                .onTapGesture { selectedRecipe = recipe }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                                .listRowSeparator(.hidden)
                            
                        }
                        .navigationTitle("Search result")
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .task {
                if (webService.recipeData?.results.count == 0) {
                    load()
                }
            }
            .sheet(item: $selectedRecipe,
                   onDismiss: { selectedRecipe = nil }) { recipe in
                SingleRecipeView(selectedRecipe: recipe)
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
    }
    
    func load() {
        Task {
            
            if let fileURL = Bundle.main.url(forResource: "testing", withExtension: "json") {
                do{
                    let jsonData = try Data(contentsOf: fileURL)
                    webService.decodeSearchJSON(from: jsonData)
                    
                } catch {
                    print("Unexpected Error!!!")
                }
            }

//            print("Tags and ingredients from search Result: \(webService.tag), \(webService.ingredients)")
//            
//            do {
//                try await webService.decodeJSON(tags: webService.tag, ingredients: webService.ingredients)
//            } catch APIError.invalidURL {
//                print("Invalid URL")
//            } catch APIError.invalidResponse {
//                print("Invalid Response")
//            } catch APIError.invalidData {
//                print("Invalid Data")
//            } catch {
//                print("Unexpected Error!!!")
//            }
        }
    }
}

#Preview {
    SearchResultView(tabSelection: .constant(2))
}
