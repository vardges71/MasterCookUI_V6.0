//
//  NutritionView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2023-12-23.
//

import SwiftUI

struct NutritionView: View {
    
    //    MARK: - PROPERTIES

        let recipe: Recipe
        
    //    MARK: - BODY
        var body: some View {
            Group {
                DisclosureGroup(content: {
                    Divider()
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
                    } .font(.system(size: 13))
                }, label: {
                    Image(systemName: "info.circle")
                    Text("Nutrition value")
                })
                .foregroundStyle(Color.accentColor)
                .background(
                    Color.clear
                )
            }
            .padding()
            .background(
                Color.white
                    .opacity(0.6)
            )
            .cornerRadius(8)
        }
}

//#Preview {
//    NutritionView(recipe: Recipe())
//}
