//
//  SettingsView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI
import FirebaseDatabase

struct SettingsView: View {
    
    @EnvironmentObject private var authServices: AuthServices
    
    @Binding var tabSelection: Int
    let title = "Settings"
    @State private var showLoginView = false
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    var currentYear = Date.now.formatted(.dateTime.year())
    
    let presentation = "MyMasterCook is a useful application that may help it’s users to find a certain recipe, based on ingredients, cuisines and even dishes that one can search in the “search” tab on the bottom of the application view"
    let linkPrivacy = "www.privacypolicies.com/live/183d1f01-e9cb-46d1-89e0-db3e27812277"
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        GroupBox(label: SettingsLabelView(labelText: "My MasterCook", labelImage: "info.circle")) {
                            Divider().padding(.vertical, 5)
                            HStack(alignment: .center, spacing: 10) {
                                Image("logoYellowNew")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                Text(presentation)
                                    .font(.footnote)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .backgroundStyle(.settingBack)
                        GroupBox(label: SettingsLabelView(labelText: "About", labelImage: "questionmark.square")
                        ) {
                            Divider().padding(.vertical, 5)
                            Text( LoadAboutText().loadAboutText(file: "AboutMyMasterCook") )
                                .font(.footnote)
                                .fontDesign(.rounded)
                                .foregroundStyle(.accent)
                        }
                        .backgroundStyle(.settingBack)
                        GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")
                        ) {
                            SettingsRowView(name: "Version", content: "\(appVersionString) (#\(buildNumber))")
                            SettingsRowView(name: "Compatibility", content: "iOS \(getMinimumVersion())")
                            SettingsRowView(name: "App Privacy", linkLabel: "privacy policy", linkDestination: linkPrivacy)
                            SettingsRowView(name: "Developer", content: "Vardges Gasparyan")
                            SettingsRowView(name: "Copyright", content: "©\(currentYear) MyMasterCook")
                        }
                        .backgroundStyle(.settingBack)
                        GroupBox(label: SettingsLabelView(labelText: "Account", labelImage: "person")) {
                            if authServices.authState == .authorised {
                                SettingsRowView(
                                    name: "",
                                    buttonLabel: "sign out",
                                    buttonImageName: "arrow.backward.square",
                                    buttonAction: {
                                        self.showAlert.toggle()
                                    }
                                )
                                .alert("Do you really want to sign out?", isPresented: $showAlert) {
                                    Button("Sign out", role: .destructive, action: {
                                        self.showLoginView.toggle()
                                        logOut()
                                    })
                                    Button("Cancel", role: .cancel, action: {})
                                }
                            } else {
                                SettingsRowView(
                                    name: "",
                                    buttonLabel: "login",
                                    buttonImageName: "arrow.forward.square",
                                    buttonAction: {
                                        self.showLoginView.toggle()
                                    }
                                )
                            }
                            if authServices.authState == .notAuthorised {
                                SettingsRowView(
                                    name: "",
                                    buttonLabel: "delete account",
                                    buttonImageName: "trash.square",
                                    buttonAction: {
                                        self.showDeleteAlert.toggle()
                                    }
                                )
                                .opacity(0.5)
                                .disabled(true)
                            } else {
                                SettingsRowView(
                                    name: "",
                                    buttonLabel: "delete account",
                                    buttonImageName: "trash.square",
                                    buttonAction: {
                                        self.showDeleteAlert.toggle()
                                    }
                                )
                                .alert("Do you really want to delete your account?", isPresented: $showDeleteAlert) {
                                    Button("Delete", role: .destructive, action: {
                                        delete()
                                        DispatchQueue.main.async {
                                            self.showLoginView.toggle()
                                        }
                                    })
                                    Button("Cancel", role: .cancel, action: {})
                                }
                            }
                        }
                        .backgroundStyle(.settingBack)
                    }
                }
                .padding(20)
            }
            .navigationTitle(title)
            .fullScreenCover(isPresented: $showLoginView) { LoginView() }
        }
    }
    
    func getMinimumVersion() -> String {
        var deploymentTarget = ""
        if let infoPlist = Bundle.main.infoDictionary {
            let minimumVersion = infoPlist["MinimumOSVersion"]
            if let minimumVersion = minimumVersion {
                print("Minimum version is \(minimumVersion)")
                deploymentTarget = minimumVersion as! String
            }
        }
        return deploymentTarget
    }
    
    func logOut() {
        do {
            try authServices.logout()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        
        let userID = authServices.uid
        let db: DatabaseReference!
        
        db = Database.database().reference()
        db.child("users").child(userID).removeValue()
        
        authServices.deleteAccount()
    }
}

#Preview {
    SettingsView(tabSelection: .constant(4))
}
