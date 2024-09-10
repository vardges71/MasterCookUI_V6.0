//
//  OneTagView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-05.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var authServices: AuthServices
    @EnvironmentObject private var webServices: WebService
    
    @State private var tabSelected = 0
    @State private var homeBadgeValue: Int?
    @State private var searchResultBadgeValue: Int?
    @State private var favoritesBadgeValue: Int?
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.navbarTint, Color.accentColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        TabView(selection: $tabSelected) {

            Group {
                HomeView(tabSelection: $tabSelected)
                    .tabItem {
                        Label("home", systemImage: tabSelected == 0 ? "house.fill" : "house") .environment(\.symbolVariants, .none)
                        
                    } .tag(0)
                    .onChange(of: webServices.recipeArray.count, { oldValue, newValue in
                        homeBadgeValue = newValue
                    })
                    .badge ( homeBadgeValue ?? 0 )
                
                SearchView(tabSelection: $tabSelected)
                    .tabItem {
                        Label("search", systemImage: tabSelected == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle") .environment(\.symbolVariants, .none)
                        
                    } .tag(1)
                
                SearchResultView(tabSelection: $tabSelected)
                    .tabItem {
                        Label("search result", systemImage: tabSelected == 2 ? "book.pages.fill" : "book.pages") .environment(\.symbolVariants, .none)
                        
                    } .tag(2)
                    .onChange(of: webServices.resultRecipeArray.count, { oldValue, newValue in
                        searchResultBadgeValue = newValue
                    })
                    .badge ( searchResultBadgeValue ?? 0 )
                
                if authServices.authState == .authorised {
                    FavoriteView(tabSelection: $tabSelected)
                        .tabItem {
                            Label("favorites", systemImage: tabSelected == 3 ? "star.fill" : "star") .environment(\.symbolVariants, .none)
                            
                        }
                        .tag(3)
                        .onChange(of: webServices.favoriteArray.count, { oldValue, newValue in
                            favoritesBadgeValue = newValue
                        })
                        .badge ( favoritesBadgeValue ?? 0 )
                }
                
                SettingsView(tabSelection: $tabSelected)
                    .tabItem {
                        Label("settings", systemImage: tabSelected == 4 ? "gearshape.2.fill" : "gearshape.2")
                            .environment(\.symbolVariants, .none)
                        
                    } .tag(4)
            }
        }
        .navigationBarTitleTextColor(.accent)
        .accentColor(Color("textColor"))
        .onAppear() {
            
            UITabBar.appearance().backgroundColor = .navbarTint
            UITabBar.appearance().barTintColor = .navbarTint
            UITabBarItem.appearance().badgeColor = .tabbarBadge
            UITabBar.appearance().unselectedItemTintColor = .navbarUnselectedItem
            
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().barTintColor = .navbarTint
        }
    }
}

#Preview {

    MainTabView()
}
