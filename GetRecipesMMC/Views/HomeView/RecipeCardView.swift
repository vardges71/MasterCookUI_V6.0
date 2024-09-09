//
//  RecipeCardView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-02.
//

import SwiftUI

struct RecipeCardView: View {
    
    var recipe: Recipe
    
    let thumbnailWidth: Double = UIScreen.main.bounds.width
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                AsyncImage(url: URL(string: recipe.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                VStack {
                    Spacer()
                    Text("\(recipe.name)")
                        .italic()
                        .padding(40)
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .fontDesign(.serif)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
                }
                .frame(width: thumbnailWidth, alignment: .bottomLeading)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .clipShape ( RoundedRectangle(cornerRadius: 20.0, style: .continuous) )
            .padding(.horizontal, 20)
        }
    }
}

//#Preview {
//    RecipeCardView()
//}


//RatingView(rating: recipe.userRatings?.score ?? 0.0)
//    .padding(3)
//    .background(
//        Color.white
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//            .opacity(0.6)
//    )
