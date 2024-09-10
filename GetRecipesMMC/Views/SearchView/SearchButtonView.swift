//
//  SearchButtonView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-07.
//

import SwiftUI

struct SearchButtonView: View {
    
    @EnvironmentObject private var webService: WebService
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    @State private var showAlert = false
    @State private var isShowResult = false
    
    @Binding var tabSelection: Int
    
    let errorSentence = """
Please enter ingredient and tap "+", to add in search list or select meal or cuisine
"""
    
    //    MARK: - BODY
    
    var body: some View {
        
        Button {
            
            ifIngredientIsEmpty()
            
        } label: {
            
            Label("search", systemImage: "doc.text.magnifyingglass")
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                .background(Color.buttonBackground)
                .foregroundStyle(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0).stroke(.white, lineWidth: 2)
                )
        }
        .alert(isPresented: self.$showAlert) { Alert(title: Text(" "), message: Text("\(errorSentence)"), dismissButton: .default(Text("OK"))) }
    }
    
    func ifIngredientIsEmpty() {
        
        if webService.tag.isEmpty && webService.ingredients.isEmpty {
            
            self.showAlert.toggle()
            
        } else {
            
            load()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                isShowResult.toggle()
                withAnimation {
                    tabSelection = 2
                }
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
    SearchButtonView(tabSelection: .constant(1))
}
