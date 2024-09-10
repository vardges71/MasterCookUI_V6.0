//
//  GuestButtonView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct GuestButtonView: View {
    
    let label: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text(label)
                .modifier(ActionButtonModifier())
                .background(Color.grey)
        }
    }
}

//#Preview {
//    GuestButtonView()
//}
