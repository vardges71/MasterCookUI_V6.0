//
//  WebService.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import Combine

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
    
    @Published var isDecodingError: Bool = false {
        willSet { objectWillChange.send() }
    }
    
    
    //  MARK: - FUNCTIONS
    
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
        
        print("URLTags: \(tagForURL ?? "")")
        
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
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error")
                return
            }
            
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
        
        var urlTags = ""
        
        if !tags.isEmpty {
            urlTags = "&tags=\(replasedTag)"
        } else {
            print("In Search NO TAGS")
        }
        
        print("URLTags: \(String(describing: replasedTag))\nURLIngredients: \(String(describing: replasedIngredient))")
        
        let headers = [
            "x-rapidapi-key": "e25b9b1e84msh0478f04ed91563dp15ca17jsn90ddd01db01f",
            "x-rapidapi-host": "tasty.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=\(s)\(urlTags)&q=\(replasedIngredient)") else {
            print("Invalid URL")
            return
        }
        print(url)
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
            isDecodingError.toggle()
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func getFavoriteRecipes() async throws {
        
        if Auth.auth().currentUser != nil {
            
            let userID = Auth.auth().currentUser?.uid
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
