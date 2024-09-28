//
//  AddButtonView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct AddButtonView: View {
    
    @EnvironmentObject private var webService: WebService
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showAlert = false
    
    var body: some View {
        
        Button {
            
            ifIngredientTextFieldIsEmpty()
            
        } label: {
            Image(systemName: "plus")
                .frame(width: 44, height: 44, alignment: .center)
                .background(.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor, lineWidth: 2)
                )
                .offset(y: -5)
        }
        .alert(isPresented: self.$showAlert) { Alert(title: Text(" "), message: Text("Please enter ingredient"), dismissButton: .default(Text("OK"))) }
    }
    
    func ifIngredientTextFieldIsEmpty(){
        
        if homeViewModel.ingredient.isEmpty {

            self.showAlert = true
            
        } else {
            
            webService.ingredients.append(homeViewModel.ingredient)
            print("WebService ingredient: \(webService.ingredients)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                homeViewModel.ingredient = ""
            }
        }
    }
}

#Preview {
    AddButtonView()
}
