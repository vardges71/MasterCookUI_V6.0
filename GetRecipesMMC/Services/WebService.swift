//
//  WebServise.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-07-08.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import Combine

//@Observable
@MainActor
class WebService: @preconcurrency ObservableObject {
    
    //  MARK: - PROPERTIES
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    let s = 50
    
    @Published var ingredients: [String] = [] {
        willSet { objectWillChange.send() }
    }
    
    @Published var tagData: TagData?
    
    @Published var tag: [String] = []  {
        willSet { objectWillChange.send() }
    }
    
    @Published var recipeData: RecipeData?
    
    @Published var recipeHomeArray: [Recipe] = [] {
        willSet { objectWillChange.send() }
    }
    @Published var recipeSearchArray: [Recipe] = [] {
        willSet { objectWillChange.send() }
    }
    @Published var isEmptyRequest: Bool = false {
        willSet { objectWillChange.send() }
    }
    
    @Published var favoriteArray: [Recipe] = [] {
        willSet { objectWillChange.send() }
    }
    @Published var favoriteDataEmpty = false {
        willSet { objectWillChange.send() }
    }
    
    @Published var isDecodeSearchJsonCalled: Bool = false {
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

        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func decodeHomeJSON(tags: String) async throws {
        
        let allowedCharacterSet = CharacterSet.urlQueryAllowed
        
        let t = tags
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
            
//            print("Data received: \(data.count) bytes")
            
            // Decoding the data
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(RecipeData.self, from: data)  // Changed variable name to decodedResponse
            
            // Update tagData (since we're already on the main actor, this is safe)
            self.recipeData = decodedResponse
            recipeHomeArray = recipeData?.results ?? []
            
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func decodeSearchJSON(tags: [String], ingredients: [String]) async throws {
        
        let ing = ingredients.joined(separator: ",")
        var replasedIngredient = ing.replacingOccurrences(of: ",", with: "%2C%20")
        replasedIngredient = ing.replacingOccurrences(of: " ", with: "%20")
        
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
            recipeSearchArray = recipeData?.results ?? []
            if recipeSearchArray.isEmpty { isEmptyRequest = true }
            
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    
    func decodeHomeJSON(from jsonData: Data) {
        
        do {
            let decoder = JSONDecoder()
            recipeData = try decoder.decode(RecipeData.self, from: jsonData)
            
            recipeHomeArray = recipeData?.results ?? []
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
            recipeSearchArray = recipeData?.results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func getFavoriteRecipes() async throws {
        
        if Auth.auth().currentUser != nil {
            
            let userID = Auth.auth().currentUser?.uid
//            print("USER ID: \(String(describing: userID))")
            let reference: DatabaseReference!
            reference = Database.database().reference(withPath: "users").child(userID!)
            
            reference.child("favorites").observeSingleEvent(of: .value) { snapshot in
                
                do {
                    
                    guard let snapChildren = snapshot.value as? [String: Any] else {
                        print("No favorites found or invalid format")
                        return
                    }
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: snapChildren)
                    let decoder = JSONDecoder()
                    let firebaseRecipes = try decoder.decode([String: Recipe].self, from: jsonData)
//                    print("Favorite RECIPES: \(firebaseRecipes)")
                    self.favoriteArray.append(contentsOf: Array(firebaseRecipes.values))
                    
                } catch {
                    print("Favorite recipes fetching error: \(error.localizedDescription)")
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        print("You fetch \(self.favoriteArray.count) favorite recipes")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
