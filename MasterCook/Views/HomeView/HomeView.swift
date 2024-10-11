//
//  HomeView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var webService: WebService
    
    @State private var selectedRecipe: Recipe? = nil
    @Binding var tabSelection: Int
    
    let title = "My MasterCook"
    
    var body: some View {
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack {
                    if webService.recipeHomeArray.isEmpty {
                        ProgressView()
                            .padding()
                            .tint(.white)
                            .foregroundColor(.white)
                    } else {
                        Spacer()
                        TabView {
                            ForEach(webService.recipeHomeArray, id: \.id) { recipe in
                                RecipeCardView(recipe: recipe)
                                    .onTapGesture { selectedRecipe = recipe }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .padding(.vertical, 20)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 5, x: -2, y: 2)
                    }
                }
            }
            .navigationTitle(title)
        }
        .task {
            
            if homeViewModel.tag.isEmpty && (homeViewModel.tag != homeViewModel.getCurrentTag()) {
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
    
    func load() {
        
        Task {
            
            do {
                try await webService.decodeHomeJSON(tags: homeViewModel.tag)
            } catch APIError.invalidURL {
                print("Invalid URL")
            } catch APIError.invalidResponse {
                print("Invalid Response")
            } catch APIError.invalidData {
                print("Invalid Data")
            } catch {
                print("Unexpected Error!!!")
            }
            print("Current HomeView Tag: \(homeViewModel.tag)")
        }
    }
}

#Preview {
    HomeView(tabSelection: .constant(0))
}
