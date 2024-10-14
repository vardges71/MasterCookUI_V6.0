//
//  SearchListView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SearchListView: View {
    
    @EnvironmentObject private var webService: WebService
    
    var body: some View {
        
        List {
            if !webService.ingredients.isEmpty {
                Section(header: Text("Ingredients:").foregroundStyle(.navbarUnselectedItem).font(.headline).padding(.leading, -20)) {
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
                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                }
            }
        }
        .scrollContentBackground(.hidden)
        .padding(.leading, -20)
        .padding(.trailing, -20)
    }
}

#Preview {
    SearchListView()
}
