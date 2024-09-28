//
//  SearchTextFieldView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SearchTextFieldView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            TextField("", text: $homeViewModel.ingredient, prompt: Text("ingredient:").foregroundStyle(Color("phTextColor")))
                .modifier(TextFieldModifier())
                .textInputAutocapitalization(.never)
                
            Divider()
        }
    }
}

#Preview {
    SearchTextFieldView()
}
