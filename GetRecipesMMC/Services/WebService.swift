//
//  WebServise.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-07-08.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

//@Observable
@MainActor
class WebService: ObservableObject {
    
    //  MARK: - PROPERTIES
    
    var ref: DatabaseReference!
    let s = 50
    
    @Published var ingredient: String = ""
    @Published var ingredients: [String] = []
    
    @Published var tagData: TagData?
    @Published var tag: [String] = []
    
    @Published var recipeData: RecipeData?
    @Published var recipeArray: [Recipe] = []
    @Published var resultRecipeArray: [Recipe] = []
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var favoriteArray: [Recipe] = [] {
        willSet { objectWillChange.send() }
    }
    @Published var favoriteDataEmpty = false {
        willSet { objectWillChange.send() }
    }
    
    
    //  MARK: - FUNCTIONS
    
    //    func decodeTagJson() async throws {
    //
    //        let headers = [
    //            "x-rapidapi-key": "e25b9b1e84msh0478f04ed91563dp15ca17jsn90ddd01db01f",
    //            "x-rapidapi-host": "tasty.p.rapidapi.com"
    //        ]
    //
    //        guard let url = URL(string: "https://tasty.p.rapidapi.com/tags/list") else {
    //            print("Invalid URL")
    //            return
    //        }
    //
    //        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
    //        request.httpMethod = "GET"
    //        request.allHTTPHeaderFields = headers
    //
    //        do {
    //            // Use async/await with URLSession
    //            let (data, response) = try await URLSession.shared.data(for: request)
    //
    //            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    //                print("HTTP Error")
    //                return
    //            }
    //
    //            print("Data received: \(data.count) bytes")
    //
    //            // Decoding the data
    //            let decoder = JSONDecoder()
    //            let decodedResponse = try decoder.decode(TagData.self, from: data)  // Changed variable name to decodedResponse
    //
    //            // Update tagData (since we're already on the main actor, this is safe)
    //            self.tagData = decodedResponse
    //
    //            // Access the tags
    //            for tag in decodedResponse.results {
    //                print("Tag Name: \(tag.name)")
    //                print("Tag Display Name: \(tag.displayName)")
    //                print("Parent Tag Name: \(String(describing: tag.parentTagName))")
    //                print("--------------------")
    //            }
    //
    //        } catch {
    //            print("Error decoding JSON: \(error.localizedDescription)")
    //        }
    //    }
    
    func decodeTagJSON(from jsonData: Data) {
        
        do {
            let decoder = JSONDecoder()
            tagData = try decoder.decode(TagData.self, from: jsonData)
            
            print("TagData results count: \(tagData?.results.count ?? 0)")
            
            //            for tag in tagData!.results {
            //                print("Tag Name: \(tag.name)")
            //                print("Tag Display Name: \(tag.displayName)")
            //                print("Parent Tag Name: \(String(describing: tag.parentTagName))")
            //
            //                print("--------------------")
            //
            //            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func decodeHomeJSON(tags: [String]) async throws {
        
        let allowedCharacterSet = CharacterSet.urlQueryAllowed
        
        let t = tags.joined(separator: ",")
        var replasedTag = t.replacingOccurrences(of: ",", with: "%2C")
        replasedTag = t.replacingOccurrences(of: " ", with: "%20")
        let tagForURL = replasedTag.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        
        print("URLTags: \(String(describing: tagForURL))")
        
        let headers = [
            "x-rapidapi-key": "e25b9b1e84msh0478f04ed91563dp15ca17jsn90ddd01db01f",
            "x-rapidapi-host": "tasty.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=\(s)&tags=\(String(describing: tagForURL))") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // Use async/await with URLSession
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error")
                return
            }
            
            print("Data received: \(data.count) bytes")
            
            // Decoding the data
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(RecipeData.self, from: data)  // Changed variable name to decodedResponse
            
            // Update tagData (since we're already on the main actor, this is safe)
            self.recipeData = decodedResponse
            resultRecipeArray = recipeData?.results ?? []
            
            // Access the tags
            //                for recipe in recipeData!.results {
            //                    print("Recipe ID: \(recipe.id)")
            //                    print("Recipe Name: \(recipe.name)")
            //                    print("Thumbnail URL: \(recipe.thumbnailURL)")
            //                    print("Video URL: \(recipe.videoURL ?? "video URL")")
            //                    for instruction in recipe.instructions {
            //                        print("Instruction: \(instruction.displayText)")
            //                    }
            //                    print("Recipe description: \(recipe.description ?? "Description")")
            //                    if let nutrition = recipe.nutrition {
            //                        print("Nutrition:")
            //                        if let calories = nutrition.calories { print("  Calories: \(calories)") }
            //                        if let carbohydrates = nutrition.carbohydrates { print("  Carbohydrates: \(carbohydrates)g") }
            //                        if let fat = nutrition.fat { print("  Fat: \(fat)g") }
            //                        if let fiber = nutrition.fiber { print("  Fiber: \(fiber)g") }
            //                        if let protein = nutrition.protein { print("  Protein: \(protein)g") }
            //                        if let sugar = nutrition.sugar { print("  Sugar: \(sugar)g") }
            //                    }
            //                    if let userRatings = recipe.userRatings {
            //                        if userRatings.score != nil { print("User Rating: \((userRatings.score ?? 0) * 5)") }
            //                    }
            //                    print("--------------------")
            
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func decodeJSON(tags: [String], ingredients: [String]) async throws {
        
        let ing = ingredients.joined(separator: ",")
        let replasedIngredient = ing.replacingOccurrences(of: ",", with: "%2C%20")
        
        let t = tags.joined(separator: ",")
        let replasedTag = t.replacingOccurrences(of: ",", with: "%2C%20")
        
        
        print("URLTags: \(String(describing: replasedTag))\nURLIngredients: \(String(describing: replasedIngredient))")
        
        let headers = [
            "x-rapidapi-key": "e25b9b1e84msh0478f04ed91563dp15ca17jsn90ddd01db01f",
            "x-rapidapi-host": "tasty.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=\(s)&tags=\(replasedTag)&q=\(replasedIngredient)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // Use async/await with URLSession
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error")
                return
            }
            
            print("Data received: \(data.count) bytes")
            
            // Decoding the data
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(RecipeData.self, from: data)  // Changed variable name to decodedResponse
            
            // Update tagData (since we're already on the main actor, this is safe)
            self.recipeData = decodedResponse
            resultRecipeArray = recipeData?.results ?? []
            
            // Access the tags
            //                for recipe in recipeData!.results {
            //                    print("Recipe ID: \(recipe.id)")
            //                    print("Recipe Name: \(recipe.name)")
            //                    print("Thumbnail URL: \(recipe.thumbnailURL)")
            //                    print("Video URL: \(recipe.videoURL ?? "video URL")")
            //                    for instruction in recipe.instructions {
            //                        print("Instruction: \(instruction.displayText)")
            //                    }
            //                    print("Recipe description: \(recipe.description ?? "Description")")
            //                    if let nutrition = recipe.nutrition {
            //                        print("Nutrition:")
            //                        if let calories = nutrition.calories { print("  Calories: \(calories)") }
            //                        if let carbohydrates = nutrition.carbohydrates { print("  Carbohydrates: \(carbohydrates)g") }
            //                        if let fat = nutrition.fat { print("  Fat: \(fat)g") }
            //                        if let fiber = nutrition.fiber { print("  Fiber: \(fiber)g") }
            //                        if let protein = nutrition.protein { print("  Protein: \(protein)g") }
            //                        if let sugar = nutrition.sugar { print("  Sugar: \(sugar)g") }
            //                    }
            //                    if let userRatings = recipe.userRatings {
            //                        if userRatings.score != nil { print("User Rating: \((userRatings.score ?? 0) * 5)") }
            //                    }
            //                    print("--------------------")
            
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    
    func decodeJSON(from jsonData: Data) {
        
        do {
            let decoder = JSONDecoder()
            recipeData = try decoder.decode(RecipeData.self, from: jsonData)
            
            recipeArray = recipeData?.results ?? []
            // Access the recipes
            /*
             for recipe in recipeData!.results {
             print("Recipe ID: \(recipe.id)")
             print("Recipe Name: \(recipe.name)")
             print("Thumbnail URL: \(recipe.thumbnailURL)")
             print("Video URL: \(recipe.videoURL ?? "video URL")")
             for instruction in recipe.instructions {
             print("Instruction: \(instruction.displayText)")
             }
             print("Recipe description: \(recipe.description ?? "Description")")
             if let nutrition = recipe.nutrition {
             print("Nutrition:")
             if let calories = nutrition.calories { print("  Calories: \(calories)") }
             if let carbohydrates = nutrition.carbohydrates { print("  Carbohydrates: \(carbohydrates)g") }
             if let fat = nutrition.fat { print("  Fat: \(fat)g") }
             if let fiber = nutrition.fiber { print("  Fiber: \(fiber)g") }
             if let protein = nutrition.protein { print("  Protein: \(protein)g") }
             if let sugar = nutrition.sugar { print("  Sugar: \(sugar)g") }
             }
             if let userRatings = recipe.userRatings {
             if userRatings.score != nil { print("User Rating: \((userRatings.score ?? 0) * 5)") }
             }
             print("--------------------")
             }
             */
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func decodeSearchJSON(from jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            recipeData = try decoder.decode(RecipeData.self, from: jsonData)
            resultRecipeArray = recipeData?.results ?? []
            // Access the recipes
            /*
             for recipe in recipeData!.results {
             print("Recipe ID: \(recipe.id)")
             print("Recipe Name: \(recipe.name)")
             print("Thumbnail URL: \(recipe.thumbnailURL)")
             print("Video URL: \(recipe.videoURL ?? "video URL")")
             for instruction in recipe.instructions {
             print("Instruction: \(instruction.displayText)")
             }
             print("Recipe description: \(recipe.description ?? "Description")")
             if let nutrition = recipe.nutrition {
             print("Nutrition:")
             if let calories = nutrition.calories { print("  Calories: \(calories)") }
             if let carbohydrates = nutrition.carbohydrates { print("  Carbohydrates: \(carbohydrates)g") }
             if let fat = nutrition.fat { print("  Fat: \(fat)g") }
             if let fiber = nutrition.fiber { print("  Fiber: \(fiber)g") }
             if let protein = nutrition.protein { print("  Protein: \(protein)g") }
             if let sugar = nutrition.sugar { print("  Sugar: \(sugar)g") }
             }
             if let userRatings = recipe.userRatings {
             if userRatings.score != nil { print("User Rating: \((userRatings.score ?? 0) * 5)") }
             }
             print("--------------------")
             }
             */
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
//    func getFavoriteRecipes() async throws -> [Recipe] {
//        
//        let userID = Auth.auth().currentUser?.uid
//        ref = Database.database().reference().child("users").child(userID!)
//        
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            
//            if snapshot.hasChild("favorites") {
//                
//                self.ref.child("favorites").observe(.childAdded) { snapshot, _ in
//                    
//                    guard let snapChildren = snapshot.value as? [String: Any] else { return }
//                    
//                    let favRecipe = Recipe()
//                    
//                    for (key, value) in snapChildren {
//                        
//                        if key == "recipeID" {
//                            
//                            favRecipe.id = value as? String ?? " "
//                        }
//                        if key == "recipeName" {
//                            
//                            favRecipe.name = value as? String ?? " "
//                        }
//                        if key == "numServings" {
//                            
//                            favRecipe.num_servings = value as? Int ?? 0
//                        }
//                        if key == "recipeInstruction" {
//                            
//                            favRecipe.instructions = value as? String ?? " "
//                        }
//                        if key == "recipeDescription" {
//                            
//                            favRecipe.description = value as? String ?? " "
//                        }
//                        if key == "recipeThumbnailURL" {
//                            
//                            favRecipe.thumbnail_url = value as? String ?? " "
//                        }
//                        if key == "recipeVideoURL" {
//                            
//                            favRecipe.video_url = value as? String ?? " "
//                        }
//                        
//                        if key == "recipeFiber" {
//                            favRecipe.fiber = (value as! Int)
//                        }
//                        if key == "recipeProtein" {
//                            favRecipe.protein = (value as! Int)
//                        }
//                        if key == "recipeFat" {
//                            favRecipe.fat = (value as! Int)
//                        }
//                        if key == "recipeCalories" {
//                            favRecipe.calories = (value as! Int)
//                        }
//                        if key == "recipeSugar" {
//                            favRecipe.sugar = (value as! Int)
//                        }
//                        if key == "recipeCarbohydrates" {
//                            favRecipe.carbohydrates = (value as! Int)
//                        }
//                    }
//                    
//                    self.favoriteArray.append(favRecipe)
//                }
//            }  else {
//                self.favoriteDataEmpty.toggle()
//            }
//        }
//        return favoriteArray
//    }
    
    func getFavoriteRecipes() async throws -> [Recipe] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let userID = Auth.auth().currentUser?.uid else {
                continuation.resume(throwing: NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"]))
                return
            }

            let ref = Database.database().reference().child("users").child(userID).child("favorites")

            ref.observeSingleEvent(of: .value) { snapshot in
                do {
                    // Extract the value as a dictionary
                    guard let value = snapshot.value as? [String: Any] else {
                        continuation.resume(returning: [])
                        return
                    }

                    // Convert snapshot value into Data
                    let jsonData = try JSONSerialization.data(withJSONObject: value)

                    // Decode into FirebaseRecipe
                    let decoder = JSONDecoder()

                    // Decode the data into an array of FirebaseRecipe
                    let firebaseRecipes = try decoder.decode([FirebaseRecipe].self, from: jsonData)

                    // Convert FirebaseRecipe to Recipe model
                    let recipes = firebaseRecipes.map { $0.toRecipe() }
                    self.favoriteArray = recipes
                    // Return the mapped recipes
                    continuation.resume(returning: recipes)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func checkFavDataEmpty() {
        
        favoriteDataEmpty = false
        
        if favoriteArray.count == 0 {
            
            Task {
                do {
                    
                    try await getFavoriteRecipes()
                    print("You fetch \(favoriteArray.count) recipes")
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
