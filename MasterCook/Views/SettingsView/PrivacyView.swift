//
//  PrivacyView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct PrivacyView: View {
    
    private var title = "Privacy Policy"
    private var privacyURL = "https://www.privacypolicies.com/live/183d1f01-e9cb-46d1-89e0-db3e27812277"
    @State private var showLoading: Bool = false
    
    var body: some View {
            
        ZStack {
            fullBackground(imageName: "backYellow")
            VStack(spacing: 0) {
                
                PrivacyViewModel(url: URL(string: privacyURL)!, showLoading: $showLoading)
                    .overlay(showLoading ? ProgressView("Loading...")
                        .progressViewStyle(.circular)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                        .tint(.white)
                        .padding()
                        .background(Color(white: 0.2, opacity: 0.7))
                        .foregroundStyle(Color.white)
                        .toAnyView() : EmptyView().toAnyView())
            }
        }
        .navigationTitle(title)
        .navigationBarTitleTextColor(Color.accentColor)
    }
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

#Preview {
    PrivacyView()
}
