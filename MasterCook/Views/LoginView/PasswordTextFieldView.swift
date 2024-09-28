//
//  PasswordTextFieldView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct PasswordTextFieldView: View {
    
    @Binding var password: String
    
    var body: some View {
        VStack {
            SecureField("", text: $password, prompt: Text("password:").foregroundStyle(Color("phTextColor")))
                .modifier(TextFieldModifier())
                .keyboardType(.default)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
            Divider()
        }
    }
}

#Preview {
    PasswordTextFieldView(password: .constant("password:"))
}
