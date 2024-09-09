//
//  RecipeScrollView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-02.
//

import SwiftUI

struct TagListView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var webService: WebService

    @State private var selectedTag: Tag? = nil
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                fullBackground(imageName: "backYellow")
                VStack {
                    List {
                        ForEach(webService.tagData?.results ?? [], id: \.id) { tag in
                            Text(tag.displayName)
                                .listRowBackground(Color.clear)
                                .foregroundStyle(.accent)
                                .onTapGesture {
                                    selectedTag = tag
                                    webService.tag.append("\(tag.name)")
                                    print("HomeViewModel tag: \(webService.tag)")
                                }
                        }
                    }
                    .navigationTitle("Tag list")
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .task {
            loadTags()
        }
        .sheet(item: $selectedTag,
               onDismiss: { selectedTag = nil }) { tag in
            HomeView(tabSelection: $tabSelection)
                .overlay(
                    Button(action: {
                        self.selectedTag = nil
                    }) {
                        Image(systemName: "xmark.circle")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 2, x: 2, y: 2)
                    }
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                    , alignment: .topTrailing
                )
        }
    }
    
    func loadTags() {

        Task {
            
            if let fileURL = Bundle.main.url(forResource: "testingTag", withExtension: "json") {
                do{
                    let jsonData = try Data(contentsOf: fileURL)
                    webService.decodeTagJSON(from: jsonData)
                    
                } catch {
                    print("Unexpected Error!!!")
                }
            }
            
//            do {
//                try await webService.decodeTagJson()
//            } catch APIError.invalidURL {
//                print("Invalid URL")
//            } catch APIError.invalidResponse {
//                print("Invalid Response")
//            } catch APIError.invalidData {
//                print("Invalid Data")
//            } catch {
//                print("Unexpected Error!!!")
//            }
        }
    }
}

#Preview {
    TagListView(tabSelection: .constant(0))
}
