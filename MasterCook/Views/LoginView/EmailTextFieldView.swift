//
//  EmailTextFieldView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct EmailTextFieldView: View {
    
    @Binding var email: String
    
    var body: some View {
        
        VStack {
            TextField("", text: $email, prompt: Text("email:").foregroundStyle(Color("phTextColor")))
                .modifier(TextFieldModifier())
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            Divider()
        }
    }
}

#Preview {
    EmailTextFieldView(email: .constant("email"))
}
