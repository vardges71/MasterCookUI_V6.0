//
//  SettingsView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var tabSelection: Int
    
    var body: some View {
        
        ZStack {
            fullBackground(imageName: "backYellow")
            VStack {
                Text("SettingsView")
            }
        }
    }
}

#Preview {
    SettingsView(tabSelection: .constant(4))
}
