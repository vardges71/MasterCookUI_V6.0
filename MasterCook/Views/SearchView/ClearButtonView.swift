//
//  ClearButtonView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct ClearButtonView: View {
    
    @EnvironmentObject private var webService: WebService
    
    var body: some View {
        
        Button {

            clearIngredients()
            print("Ingredient Array count: \(webService.ingredients.count)")
            
        } label: {
            Label("clear", systemImage: "trash")
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                .background(.yellowbutton)
                .foregroundStyle(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0).stroke(.accent, lineWidth: 2)
                )
        }
    }
    
    func clearIngredients() {
        
        webService.ingredients.removeAll()
        webService.tag.removeAll()
    }
}

#Preview {
    ClearButtonView()
}
