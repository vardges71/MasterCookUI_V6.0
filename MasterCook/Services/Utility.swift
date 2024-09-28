//
//  Utility.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

public extension View {
    
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        
        return self
    }
    
    func optionalIntView(_ property: Int?) -> Text {
        
        if let unwrappedProperty = property {
            
            return Text("serving \(unwrappedProperty == 0 ? "n/a" : "\(unwrappedProperty)") peoples")
                .font(.system(size: 13, design: .rounded))
                .fontWeight(.bold)
            
        } else {
            return Text("n/a")
        }
    }
    
    func optionalDoubleView(_ property: Int?) -> Text {
        
        if let unwrappedProperty = property {
            
            return Text("\(unwrappedProperty)")
            
        } else {
            return Text("n/a")
        }
    }
    
    func fullBackground(imageName: String) -> some View {
        
        ZStack {
            GeometryReader { proxy in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
            LinearGradient(gradient: Gradient(colors: [Color.navbarTint, Color.accentColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .opacity(0.5)
        }.ignoresSafeArea()
    }
}

struct TextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .foregroundStyle(Color("textColor"))
            .accentColor(Color("textColor"))
    }
}

struct ActionButtonModifier: ViewModifier {

    func body(content: Content) -> some View {

        content
            .frame(width: UIScreen.main.bounds.width - 40, height: 44, alignment: .center)
            .font(.system(size: 17.0))
            .foregroundStyle(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5.0).stroke(.white, lineWidth: 2)
            )
    }
}
