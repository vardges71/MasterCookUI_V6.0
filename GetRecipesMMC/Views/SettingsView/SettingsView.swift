//
//  SettingsView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var authServices: AuthServices
    @Binding var tabSelection: Int
    
    var body: some View {
        
        ZStack {
            fullBackground(imageName: "backYellow")
            VStack {
                
                Text("SettingsView")
                Button("log out") {
                    logOut()
                }
            }
        }
    }
    
    func logOut() {
        do {
            try authServices.logout()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    SettingsView(tabSelection: .constant(4))
}
