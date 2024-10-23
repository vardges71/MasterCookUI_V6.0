//
//  SearchView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var webService: WebService
    @FocusState private var nameIsFocused: Bool

    
    private let title = "Search"
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack(spacing: 20) {
                    SearchListView()
                    HStack(spacing: 10) {
                        SearchTextFieldView()
                            .focused($nameIsFocused)
                        Spacer()
                        AddButtonView(dismissKeyboard: { nameIsFocused = false })
                    }
                    VStack {
                        MealScrollView()
                        CuisineScrollView()
                        DietaryScrollView()
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        ClearButtonView()
                        SearchButtonView(tabSelection: $tabSelection)
                    }
                    Spacer()
                }
                .onTapGesture {
                    nameIsFocused = false  // Dismiss keyboard on tap outside
                }
                .padding(20)
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
