//
//  SearchTextFieldView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-06.
//

import SwiftUI

struct SearchTextFieldView: View {
    
    @EnvironmentObject private var webService: WebService
    @State private var ingredient: String = ""
    
    var body: some View {
        VStack {
            TextField("", text: $webService.ingredient, prompt: Text("ingredient:").foregroundStyle(Color("phTextColor")))
                .modifier(TextFieldModifier())
                .textInputAutocapitalization(.never)
                
            Divider()
        }
//        .onChange(of: ingredient) { oldValue, newValue in
//            webService.ingredient = newValue
//            print(webService.ingredient)
//        }
    }
}

#Preview {
    SearchTextFieldView()
}
