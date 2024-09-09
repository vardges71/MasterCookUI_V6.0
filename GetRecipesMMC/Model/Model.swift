//
//  Model.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-07-08.
//

import Foundation

struct Recipe: Codable, Identifiable {
    
    let id: Int
    let name: String
    let thumbnailURL: String
    let videoURL: String?
    let description: String?
    let numServings: Int?
    let instructions: [Instruction]
    let nutrition: Nutrition?
    let userRatings: UserRatings?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
        case numServings = "num_servings"
        case description
        case instructions
        case nutrition
        case userRatings = "user_ratings"
    }
}

struct Instruction: Codable {
    let displayText: String
    
    enum CodingKeys: String, CodingKey {
        case displayText = "display_text"
    }
}

struct Nutrition: Codable {
    let calories: Int?
    let carbohydrates: Int?
    let fat: Int?
    let fiber: Int?
    let protein: Int?
    let sugar: Int?
}

struct UserRatings: Codable {
    let score: Double?
}

struct RecipeData: Codable {
    
    let results: [Recipe]
}


struct FirebaseRecipe: Codable {
    let recipeID: Int
    let recipeName: String
    let thumbnailURL: String
    let videoURL: String?
    let recipeDescription: String?
    let numServings: Int?
    let instructions: [Instruction]
    let nutrition: Nutrition?
    let userRatings: UserRatings?
    
    // CodingKeys to map Firebase keys to this struct
    enum CodingKeys: String, CodingKey {
        case recipeID = "recipe_id"
        case recipeName = "recipe_name"
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
        case recipeDescription = "recipe_description"
        case numServings = "num_servings"
        case instructions = "recipe_instructions"
        case nutrition = "recipe_nutrition"
        case userRatings = "user_ratings"
    }
    
    func toRecipe() -> Recipe {
        return Recipe(
            id: recipeID,
            name: recipeName,
            thumbnailURL: thumbnailURL,
            videoURL: videoURL,
            description: recipeDescription,
            numServings: numServings,
            instructions: instructions,
            nutrition: nutrition,
            userRatings: userRatings
        )
    }
}



struct Tag: Codable, Identifiable {
    
    var displayName: String
    var id: Int
    var name: String
    var parentTagName: String?
    var rootTagType: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case id
        case name
        case parentTagName = "parent_tag_name"
        case rootTagType = "root_tag_type"
    }
}

struct TagData: Codable {
    
    let results: [Tag]
}
