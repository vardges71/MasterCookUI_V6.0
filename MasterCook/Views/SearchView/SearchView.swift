//
//  SearchView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var webService: WebService
    
    private let title = "Search"
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack {
                    SearchListView()
                    VStack {
                        HStack(spacing: 10) {
                            SearchTextFieldView()
//                            Spacer()
                            AddButtonView()
                        }
                        MealScrollView()
                        CuisineScrollView()
                        Spacer()
                        HStack(spacing: 20) {
                            ClearButtonView()
                            SearchButtonView(tabSelection: $tabSelection)
                        }
                        Spacer()
                    }
                    .padding(20)
                }
                Spacer()
            }
            .navigationTitle(title)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                webService.ingredients.removeAll()
                webService.tag.removeAll()
            }
        }
    }
}

#Preview {
    SearchView(tabSelection: .constant(1))
}
