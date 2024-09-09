//
//  AddButtonView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-06.
//

import SwiftUI

struct AddButtonView: View {
    
    @EnvironmentObject private var webService: WebService
    @State private var showAlert = false
    
    var body: some View {
        
        Button {
            
            ifIngredientTextFieldIsEmpty()
            print("Ingredient Array count: \(webService.ingredients.count)")
            
        } label: {
            Image(systemName: "plus")
                .frame(width: 44, height: 44, alignment: .center)
                .background(.yellowbutton)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0).stroke(Color.accentColor, lineWidth: 2)
                )
                .offset(y: -7)
        }
        .alert(isPresented: self.$showAlert) { Alert(title: Text(" "), message: Text("Please enter ingredient"), dismissButton: .default(Text("OK"))) }
    }
    
    func ifIngredientTextFieldIsEmpty(){
        
        if webService.ingredient.isEmpty {

            self.showAlert = true
            
        } else {
            
            webService.ingredients.append(webService.ingredient)
            webService.ingredient = ""
            
        }
    }
}

#Preview {
    AddButtonView()
}
