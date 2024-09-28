//
//  AuthServices.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

enum AuthStates {
    
    case undefined
    case authorised
    case notAuthorised
}

class AuthServices: ObservableObject {
    
    @Published var authState: AuthStates = .undefined
    @Published var uid: String = ""
    
    var userAuth = false
    
    init() {
        
        setupAuthListener()
    }
    
    func setupAuthListener() {
        
        let _ = Auth.auth().addStateDidChangeListener { _, user in
            
            self.authState = user == nil ? .notAuthorised : .authorised
            guard let user = user else { return }
            self.uid = user.uid
        }
    }
    
    func signUp(_ email: String, password: String, re_password: String) async throws {
        
        try await Auth.auth().createUser(withEmail: email, password: password)
        guard uid != "" else { return }
        try createProfile(email: email)
    }
    
    func createProfile(email: String) throws {
        
        let reference: DatabaseReference!
        reference = Database.database().reference(withPath: "users").child(uid).child("credentials")
        reference.setValue(["email" : email])
    }
    
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Account deleted.
                print("ACCOUNT DELETED")
            }
        }
    }
    
    func forgotPassword(email: String) async throws {
        
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
