//
//  LogOutButtonView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct LogOutButtonView: View {
    
    @EnvironmentObject private var authServices: AuthServices
    
    @State private var showLoginView = false
    @State private var showAlert = false
    
    var body: some View {
        
        Button() {
            
            self.showAlert.toggle()
            
        } label: {
            
            HStack {
                Image(systemName: "arrow.backward.square")
            }
        }
        .foregroundStyle(Color.accentColor)
        .alert("Do you really want to sign out?", isPresented: $showAlert) {
            
            Button("Sign out", role: .destructive, action: {
                
                self.showLoginView.toggle()
                logout()
            })
            
            Button("Cancel", role: .cancel, action: {})
        }
        .fullScreenCover(isPresented: $showLoginView) { MainView() }
    }
    
    func logout() {
        do {
            try authServices.logout()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    LogOutButtonView()
}
