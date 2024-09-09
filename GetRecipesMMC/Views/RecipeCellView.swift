//
//  RecipeCellView.swift
//  MyMasterCook
//
//  Created by Vardges Gasparyan on 2022-11-02.
//

import SwiftUI

struct RecipeCellView: View {
    
//    MARK: - PROPERTIES
    
    var recipe: Recipe
//    let thumbnailWidth: Double = UIScreen.main.bounds.width * 0.25

    
//    MARK: - BODY
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            HStack {

                AsyncImage(url: URL(string: recipe.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 125)
                .clipShape ( RoundedRectangle(cornerRadius: 10.0, style: .continuous) )
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(recipe.name)")
                        .font(.system(size: 16, design: .rounded))
                        .bold()
                        .shadow(radius: 3)
                        .lineLimit(2)
                    RatingView(rating: recipe.userRatings?.score ?? 0.0)
                    Spacer()
                    Group {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("fiber: \(optionalDoubleView(recipe.nutrition?.fiber))")
                                Text("proteine: \(optionalDoubleView(recipe.nutrition?.protein))")
                                Text("fat: \(optionalDoubleView(recipe.nutrition?.fat))")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("sugar: \(optionalDoubleView(recipe.nutrition?.sugar))")
                                Text("carbohydrates: \(optionalDoubleView(recipe.nutrition?.carbohydrates))")
                                Text("calories: \(optionalDoubleView(recipe.nutrition?.calories))")
                            }
                        }
                        .font(.system(size: 11))
                    }
                    optionalIntView(recipe.numServings)
                }
                .foregroundStyle(.accent)
            }
            Divider()
        }
    }
}

// MARK: - PREVIEW

//#Preview {
//    
//    RecipeCellView()
//}

