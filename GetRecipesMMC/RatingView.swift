//
//  RatingView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-07-28.
//

import SwiftUI

struct RatingView: View {
    
    let rating: Double
    let maxRating: Int = 5
    let fullStar = Image(systemName: "star.fill")
    let halfStar = Image(systemName: "star.lefthalf.fill")
    let emptyStar = Image(systemName: "star")
    
    let starColor = Gradient(colors: [.navbarTint, .yellow])

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<maxRating, id: \.self) { index in
                self.starType(for: index)
                    .foregroundStyle(.tabbarBadge)
//                    .shadow(color: .white, radius: 2)
                    .font(.system(size: 11))
            }
        }
    }

    func starType(for index: Int) -> Image {
        
        let scaledRating = rating * Double(maxRating)
        let threshold = Double(index) + 0.5
        
        if scaledRating >= Double(index + 1) {
            return fullStar
        } else if scaledRating >= threshold {
            return halfStar
        } else {
            return emptyStar
        }
    }
}

#Preview {
    RatingView(rating: 0.25)
}
