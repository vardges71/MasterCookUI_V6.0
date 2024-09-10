//
//  Utility.swift
//  MyMasterCook
//
//  Created by Vardges Gasparyan on 2022-10-26.
//

import SwiftUI
//import FirebaseAuth
//import FirebaseDatabase
//import Firebase

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
            //                .foregroundColor(Colors.textColor)
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
//        let gradientColor = [Color.navbarTint, Color.accentColor]
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

enum CommodityColor {
    
    case gold
    case silver
    case platinum
    case bronze
    
    var colors: [Color] {
        
        switch self {
        case .gold: return [ Color("#DBB400"),
                             Color("#EFAF00"),
                             Color("#F5D100"),
                             Color("#F5D100"),
                             Color("#D1AE15"),
                             Color("#DBB400"),
                             
        ]
            
        case .silver: return [ Color("#70706F"),
                               Color("#7D7D7A"),
                               Color("#B3B6B5"),
                               Color("#8E8D8D"),
                               Color("#B3B6B5"),
                               Color("#A1A2A3"),
        ]
            
        case .platinum: return [ Color("#000000"),
                                 Color("#444444"),
                                 Color("#000000"),
                                 Color("#444444"),
                                 Color("#111111"),
                                 Color("#000000"),
        ]
            
        case .bronze: return [ Color("#804A00"),
                               Color("#9C7A3C"),
                               Color("#B08D57"),
                               Color("#895E1A"),
                               Color("#804A00"),
                               Color("#B08D57"),
        ]}
    }
    
    var linearGradient: LinearGradient
    {
        return LinearGradient(
            gradient: Gradient(colors: self.colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
