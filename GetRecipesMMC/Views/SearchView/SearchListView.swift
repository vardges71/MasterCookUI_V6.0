//
//  SearchListView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-06.
//

import SwiftUI

struct SearchListView: View {
    
    @EnvironmentObject private var webService: WebService
    
    var body: some View {
        
        List {
            ForEach(0..<webService.ingredients.count, id: \.self) { index in
                VStack(alignment: .leading, spacing: 5) {
                    Text(webService.ingredients[index])
                        .swipeActions(allowsFullSwipe: true) {
                            
                            Button(role: .destructive) {
                                
                                webService.ingredients.remove(at: index)
                            } label: {
                                
                                Label("Delete", systemImage: "trash")
                            } .tint(Color.tabbarBadge)
                        }
                        .foregroundStyle(Color.accentColor)
                    Divider()
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    SearchListView()
}
