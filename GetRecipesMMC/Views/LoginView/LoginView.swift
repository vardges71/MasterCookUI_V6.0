//
//  LoginView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-09.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var authServices: AuthServices
    @EnvironmentObject private var webService: WebService
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var re_password: String = ""
    
    @State private var showLoginAlert = false
    @State private var errorDescription: String = ""
    
    @State private var isShowReg = false
    @State private var isShowMainTab = false
    @State private var isErrorExist = false
    
    @State private var alertType: LoginViewAlerts = .success
    
    var body: some View {
        ZStack {
            fullBackground(imageName: "backYellow")
            VStack {
                Spacer()
                Image("logoYellowNew")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210)
                Spacer()
                VStack(spacing: 20) {
                    EmailTextFieldView(email: $email)
                    PasswordTextFieldView(password: $password)
                    if isShowReg {
                        RePasswordTextFieldView(re_password: $re_password)
                    }
                    LoginButtonView(label: isShowReg ? "sign up" : "login") {
                        authenticate()
                    }
                    GuestButtonView(label: "continue as guest") {
                        print("Guest button tapped!!!")
                        isShowMainTab.toggle()
                    }
                    HStack {
                        Button(isShowReg ? "back to login" : "register") {
                            
                            isShowReg.toggle()
                        }
                        Spacer()
                        Button("forgot password?") {
                            forgotButtonTapped()
                        }
                    } .foregroundStyle(Color("textColor"))
                } .padding(40)
            }
        }
        .fullScreenCover(isPresented: $isShowMainTab) { MainTabView() }
        .alert(isPresented: $showLoginAlert) { getAlert() }
        .task {
            webService.recipeHomeArray.removeAll()
            webService.recipeSearchArray.removeAll()
            webService.favoriteArray.removeAll()
        }
    }
    
    func validateFields() {

        if password != re_password {
            isErrorExist = true
            alertType = .passwordsNotSame
        } else {
            isErrorExist = false
            alertType = .unowned
        }
    }
    
    func authenticate() {
        validateFields()
        Task {
            do {
                if isShowReg {
                    if isErrorExist {
                        showLoginAlert.toggle()
                        
                    } else {
                        try await authServices.signUp(email, password: password, re_password: re_password)
                    }
                } else {
                    try await authServices.login(email: email, password: password)
                }
            } catch {
                showLoginAlert.toggle()
                errorDescription = error.localizedDescription
                alertType = .wasError
            }
        }
    }
    
    func forgotButtonTapped() {
        
        showLoginAlert.toggle()
        
        Task {
            do {
                try await authServices.forgotPassword(email: email)
                alertType = .forgotPassword
                
            } catch {
                print(error.localizedDescription)
                errorDescription = error.localizedDescription
                alertType = .wasError
            }
        }
    }
    
    func getAlert() -> Alert {
        
        switch alertType {
            
        case .passwordsNotSame:
            return Alert(title: Text("Error..."), message: Text("Please enter the same password in the \"password\" and \"confirm password\" fields"))
        case .forgotPassword:
            return Alert(title: Text("Success..."), message: Text("Please check your email inbox"))
        case.success:
            return Alert(title: Text("Success..."), message: Text("You are successfully registered!"))
        case .wasError:
            return Alert(title: Text("Error..."), message: Text("\(errorDescription)"))
        case .unowned:
            return Alert(title: Text("Error..."), message: Text("\(errorDescription)"))
        }
    }
}

#Preview {
    LoginView()
}
