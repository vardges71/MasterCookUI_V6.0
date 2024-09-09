//
//  ToolBarFavoriteButton.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2023-12-23.
//

import SwiftUI
//import FirebaseDatabase

struct ToolBarFavoriteButton: View {
    
//    @EnvironmentObject private var authServices: AuthServices
//    @EnvironmentObject private var webServices: WebServices
//    
//    let selectedRecipe: Recipe
//    
//    let ref = Database.database().reference()
//    
//    @State private var isDisabled: Bool = false
//    @State private var isExist: Bool = false
//    @State private var isShowDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            
        }
//        Button {
//            
//            do{
//                isExist.toggle()
//                print("Favorite Button")
//                try add_removeFavorites()
//                
//            } catch {
//                print(error.localizedDescription)
//            }
//        } label: {
//            VStack {
//                Image(systemName: isExist ? "star.fill" : "star")
//                    .environment(\.symbolVariants, .none)
//                Text("favorite")
//                    .font(.caption)
//            }
//            .foregroundStyle(Color.accentColor)
//            .opacity(isDisabled ? 0.5 : 1)
//        }
//        .disabled(isDisabled)
//        .onAppear {
//            isUserExist()
//            checkRecipeExist()
//        }
//        .actionSheet(isPresented: $isShowDeleteAlert) {
//            ActionSheet(
//                title: Text("Do you really want to remove recipe from your favorites?"),
//                buttons: [
//                    
//                    .destructive(Text("Remove")) {
//                        deleteFavorite()
//                        isExist = false
//                    },
//                    .cancel(Text("Cancel")) {
//                        isExist = true
//                        
//                    }
//                ]
//            )
//        }
//    }
//    
//    func isUserExist() {
//        
//        if authServices.authState == .notAuthorised {
//            isDisabled = true
//        } else {
//            isDisabled = false
//        }
//    }
//    
//    func add_removeFavorites() throws {
//        
//        if isExist {
//            try addToFavorite()
//            
//        } else {
//            isShowDeleteAlert.toggle()
//        }
//    }
//    
//    func checkRecipeExist() {
//        
//        let userID = authServices.uid
//        let recipeID = selectedRecipe.id
//        
//        if isDisabled == false {
//            ref.child("users").child(userID).child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                if (snapshot.hasChild(recipeID)) {
//                    isExist = true
//                    print("FAVORITE EXIST")
//                } else {
//                    isExist = false
//                    print("FAVORITE IS NOT EXIST")
//                }
//            })
//        }
//    }
//    
//    func deleteFavorite() {
//        
//        let recipeID = selectedRecipe.id
//        let userID = authServices.uid
//
//            self.ref.child("users").child(userID).child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
//
//                if snapshot.hasChild(recipeID){
//
//                    self.ref.child("users").child(userID).child("favorites").child(recipeID).removeValue()
//                    checkRecipeExist()
//                }
//            })
//    }
//    
//    func addToFavorite() throws {
//        
//        let recipeID = selectedRecipe.id
//        let recipeName = selectedRecipe.name
//        let recipeThumbnailUrl = selectedRecipe.thumbnail_url
//        let recipeVideoURL = selectedRecipe.video_url
//        let recipeInstruction = selectedRecipe.instructions
//        let recipeDescription = selectedRecipe.description
//        let numServings = selectedRecipe.num_servings ?? 0
//        
//        let recipeFiber = selectedRecipe.fiber
//        let recipeProtein = selectedRecipe.protein
//        let recipeFat = selectedRecipe.fat
//        let recipeCalories = selectedRecipe.calories
//        let recipeSugar = selectedRecipe.sugar
//        let recipeCarbohydrates = selectedRecipe.carbohydrates
//        
//        let userID = authServices.uid
//        
//        print(userID)
//        
//        do {
//            ref.child("users").child(userID).child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                if (snapshot.hasChild(recipeID)) {
//                    
//                    // ALERT
//                    
//                } else {
//                    
//                    let reference = Database.database().reference(withPath: "users").child(userID).child("favorites").child(recipeID)
//                    reference.setValue([
//                        "recipeID": recipeID as Any,
//                        "recipeName": recipeName as Any,
//                        "recipeThumbnailURL": recipeThumbnailUrl as Any,
//                        "recipeVideoURL": recipeVideoURL as Any,
//                        "recipeInstruction": recipeInstruction as Any,
//                        "recipeDescription": recipeDescription as Any,
//                        "numServings": numServings as Any,
//                        "recipeFiber": recipeFiber as Any,
//                        "recipeProtein": recipeProtein as Any,
//                        "recipeFat": recipeFat as Any,
//                        "recipeCalories": recipeCalories as Any,
//                        "recipeSugar": recipeSugar as Any,
//                        "recipeCarbohydrates": recipeCarbohydrates as Any
//                        
//                    ])
//                }
//            })
//        }
    }
}

//#Preview {
//    ToolBarFavoriteButton(selectedRecipe: Recipe())
//}
