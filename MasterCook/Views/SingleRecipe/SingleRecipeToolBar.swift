//
//  SingleRecipeToolBar.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SingleRecipeToolBar: View {

    let selectedRecipe: Recipe
    
    var body: some View {

        ZStack {
            HStack {
                ToolBarPlayButton(selectedRecipe: selectedRecipe)
                Spacer()
                ToolBarPrintButton(selectedRecipe: selectedRecipe)
                Spacer()
                ToolBarFavoriteButton(selectedRecipe: selectedRecipe)
            }
            .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05)
        .background(Color.navbarTint)
    }
}

//#Preview {
//    SingleRecipeToolBar()
//}
