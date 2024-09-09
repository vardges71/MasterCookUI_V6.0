//
//  FavoriteView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct FavoriteView: View {
    
    @Binding var tabSelection: Int
    let title = "Favorites"
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack{
                    FavoritesListView(tabSelected: $tabSelection)
                }
            }
            .navigationTitle(title)
        }
    }
}

#Preview {
    FavoriteView(tabSelection: .constant(3))
}
