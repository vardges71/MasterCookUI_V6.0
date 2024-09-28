//
//  RePasswordTextFieldView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct RePasswordTextFieldView: View {
    
    @Binding var re_password: String
    
    var body: some View {
        VStack {
            SecureField("", text: $re_password, prompt: Text("confirm password:").foregroundStyle(Color("phTextColor")))
                .modifier(TextFieldModifier())
                .keyboardType(.default)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
            Divider()
        }
    }
}

#Preview {
    RePasswordTextFieldView(re_password: .constant("confirm password:"))
}
