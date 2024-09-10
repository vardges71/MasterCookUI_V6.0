//
//  SettingsLoginButtonView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-10.
//

import SwiftUI

struct SettingsLoginButtonView: View {
    
    @State private var showLoginView = false
    
    var body: some View {
        
        Button() {
            self.showLoginView.toggle()
        } label: {
            HStack {
                Image(systemName: "arrow.forward.square")
            }
        }
        .foregroundColor(Color.accentColor)
        .fullScreenCover(isPresented: $showLoginView) { MainView() }
    }
}

#Preview {
    SettingsLoginButtonView()
}
