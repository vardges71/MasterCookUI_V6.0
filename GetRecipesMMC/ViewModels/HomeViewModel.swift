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
    
    @MainActor func mainGreetingText() -> String {
        
        let hour = Calendar.current.component(.hour, from: Date())
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        
        switch hour {
            
        case 06...11:
            self.greetingText = "Good morning,\nIt's time for breakfast"
            tag = "breakfast"
            print("HVM tag: \(tag)")
        case 12...15:
            self.greetingText = "Good afternoon,\nTime for lunch"
            tag = "lunch"
            print("HVM tag: \(tag)")
        case 16...17:
            self.greetingText = "Good day,\nWhat about dessert?"
            tag = "desserts"
            print("HVM tag: \(tag)")
        case 18...21:
            self.greetingText = "Good evening,\nLet's have dinner"
            tag = "dinner"
            print("HVM tag: \(tag)")
        default:
            self.greetingText = "Maybe snacks?"
            tag = "snacks"
            print("HVM tag: \(tag)")
        }
        
        return greetingText
    }
}
