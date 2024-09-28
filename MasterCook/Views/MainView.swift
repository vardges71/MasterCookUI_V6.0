//
//  MainView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var authServices: AuthServices

    var body: some View {
 
        Group {
            switch authServices.authState {
                
            case .undefined:
                ProgressView()
            case .authorised:
                ContentView()
            case .notAuthorised:
                LoginView()
            }
        }
    }
}

#Preview {
    MainView()
}
