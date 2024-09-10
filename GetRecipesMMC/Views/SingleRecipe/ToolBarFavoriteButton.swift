//
//  ToolBarFavoriteButton.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2023-12-23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

struct ToolBarFavoriteButton: View {
    
    @EnvironmentObject private var authServices: AuthServices
    @EnvironmentObject private var webService: WebService
    
    let selectedRecipe: Recipe
    
    @State private var isDisabled: Bool = false
    @State private var isExist: Bool = false
    @State private var isShowDeleteAlert: Bool = false
    
    var body: some View {
        Button {
            
            do{
                isExist.toggle()
                print("Favorite Button")
                try add_removeFavorites()
                
            } catch {
                print(error.localizedDescription)
            }
        } label: {
            VStack {
                Image(systemName: isExist ? "star.fill" : "star")
                    .environment(\.symbolVariants, .none)
                Text("favorite")
                    .font(.caption)
            }
            .foregroundStyle(Color.accentColor)
            .opacity(isDisabled ? 0.5 : 1)
        }
        .disabled(isDisabled)
        .onAppear {
            isUserExist()
            checkRecipeExist()
        }
        .actionSheet(isPresented: $isShowDeleteAlert) {
            ActionSheet(
                title: Text("Do you really want to remove recipe from your favorites?"),
                buttons: [
                    
                    .destructive(Text("Remove")) {
                        deleteFavorite()
                        isExist = false
                    },
                    .cancel(Text("Cancel")) {
                        isExist = true
                        
                    }
                ]
            )
        }
    }
    
    func isUserExist() {
        
        if authServices.authState == .notAuthorised {
            isDisabled = true
        } else {
            isDisabled = false
        }
    }
    
    func add_removeFavorites() throws {
        
        if isExist {
            try addToFavorite()
            
        } else {
            isShowDeleteAlert.toggle()
        }
    }
    
    func checkRecipeExist() {
        
        let userID = authServices.uid
        let recipeID = String(selectedRecipe.id)
        
        if isDisabled == false {
            let reference: DatabaseReference!
            reference = Database.database().reference(withPath: "users")
            reference.child(userID).child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.hasChild(recipeID)) {
                    isExist = true
                    print("FAVORITE EXIST")
                } else {
                    isExist = false
                    print("FAVORITE IS NOT EXIST")
                }
            })
        }
    }
    
    func deleteFavorite() {
        
        let recipeID = String(selectedRecipe.id)
        let userID = authServices.uid
        let reference: DatabaseReference!
        reference = Database.database().reference(withPath: "users").child(userID)
        reference.child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(recipeID){
                
                reference.child("favorites").child(recipeID).removeValue()
                checkRecipeExist()
            }
        })
    }
    
    func addToFavorite() throws {
        
        Task {
            do {
                try saveRecipeToFirebase(recipe: selectedRecipe)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func recipeToDictionary(recipe: Recipe) -> [String: Any]? {
        do {
            
            let jsonData = try JSONEncoder().encode(recipe)
            
            print("Favorite JSON Data: \(jsonData)")
            if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print("Favorite JSON Dictionary: \(jsonDictionary)")
                return jsonDictionary
            }
            
        } catch {
            print("Error converting recipe to dictionary: \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveRecipeToFirebase(recipe: Recipe) throws {
        
        let userID = authServices.uid
        
        let reference: DatabaseReference!
        reference = Database.database().reference(withPath: "users").child(userID).child("favorites").child("\(recipe.id)")
        
        if let recipeDictionary = recipeToDictionary(recipe: recipe) {
            
            reference.setValue(recipeDictionary) { (error, ref) in
                
                if let error = error {
                    print("Error saving recipe to Firebase: \(error.localizedDescription)")
                } else {
                    print("Recipe saved successfully to Firebase.")
                }
            }
        } else {
            print("Failed to convert Recipe to dictionary.")
        }
    }
}

//#Preview {
//    ToolBarFavoriteButton(selectedRecipe: Recipe())
//}

