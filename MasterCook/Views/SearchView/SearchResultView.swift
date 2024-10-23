//
//  SearchResultView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SearchResultView: View {
    
    @EnvironmentObject private var webService: WebService
    
    @State private var selectedRecipe: Recipe? = nil
    
    @State private var showAlert: Bool = false
    @State private var resultAlertTypes: SearchViewAlerts = .success
    
    @Binding var tabSelection: Int
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack {
                    if webService.recipeSearchArray.isEmpty {
                        
                        ProgressView()
                            .padding()
                            .tint(.white)
                            .foregroundColor(.white)
                            .onReceive(webService.$isEmptyRequest) { newValue in
                                showAlert = newValue
                                resultAlertTypes = .emptyRequest
                                print("New Value: \(newValue),\nWebService isEmptyRequrst: \(webService.isEmptyRequest)")
                            }
                            .onReceive(webService.$isDecodingError) { newValue in
                                showAlert = newValue
                                resultAlertTypes = .errorDecoding
                            }
                    } else {
                        List(webService.recipeSearchArray, id: \.id) { recipe in
                            
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
        .alert(isPresented: self.$showAlert) { showResultAlert() }
        
    }
    
    func showResultAlert() -> Alert {
        
        switch resultAlertTypes {
            
        case .emptyRequest:
            return Alert(
                title: Text("Request Empty..."),
                message: Text("Nothing found from your request"),
                dismissButton: .default(Text("OK"), action: {
                    withAnimation {
                        tabSelection = 1
                    }
                    showAlert = false
            }))
        case .emptySearchParameters:
            return Alert(
                title: Text("Ingredients, meal or cuisine not selected"),
                message: Text("""
Please enter ingredient and tap "+", to add in search list or select meal or cuisine
"""),
                dismissButton: .default(Text("OK"), action: {
                    
                    withAnimation {
                        tabSelection = 1
                    }
                    showAlert = false
            }))
        case .errorDecoding:
            return Alert(
                title: Text("The data could be missing"),
                message: Text("""
Please try to add meal or cuisine
"""),
                dismissButton: .default(Text("OK"), action: {
                    
                withAnimation {
                    tabSelection = 1
                }
                showAlert = false
            }))
        case .success:
            return Alert(title: Text("Request Success"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                withAnimation {
                    tabSelection = 2
                }
                showAlert = false
            }))
        }
    }
}

#Preview {
    SearchResultView(tabSelection: .constant(2))
}
