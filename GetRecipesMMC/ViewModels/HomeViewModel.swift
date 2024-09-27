//
//  HomeViewModel.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-03.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    let formatter = DateFormatter()
    
    @Published var greetingText: String = ""
    @Published var tag: String = ""
    @Published var timeToChangeTag = false
    
    @Published var ingredient: String = ""
    
    @MainActor func getCurrentTag() -> String {
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            
        case 6...11:
            tag = "breakfast"
        case 12...15:
            tag = "lunch"
        case 16...17:
            tag = "desserts"
        case 18...21:
            tag = "dinner"
        default:
            tag = "snacks"
        }
        
        print("Current Tag: \(tag)")
        return tag
    }
}
