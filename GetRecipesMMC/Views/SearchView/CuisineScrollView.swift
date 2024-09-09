//
//  CuisineScrollView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-07.
//

import SwiftUI

struct CuisineScrollView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var webService: WebService

    @State private var selectedTag: Tag? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("cuisines:")
                .font(.caption)
                .foregroundStyle(.accent)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(webService.tagData?.results ?? [], id: \.id) { tag in
                        if tag.parentTagName == "cuisine" {
                            
                            let isSelected = selectedTag?.id == tag.id
                            let foregroundColor = isSelected ? Color.white : Color.accent
                            let backgroundColor = isSelected ? Color.accent.opacity(0.8) : Color.white.opacity(0.8)
                            
                            Text(tag.displayName)
                                .font(.footnote)
                                .onTapGesture {
                                    handleTagSelection(tag)
                                }
                                .foregroundStyle(foregroundColor)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(backgroundColor)
                                )
                                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 2, x: 2, y: 2)
                        }
                    }
                }
            }
            .frame(height: 25)
            Spacer()
        }
        .scrollClipDisabled(true)
        .scrollIndicators(.hidden)
        .task {
            loadTags()
            selectedTag = nil
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
    
    func handleTagSelection(_ tag: Tag) {
        if selectedTag?.id == tag.id {
            if let selectedName = selectedTag?.name {
                 webService.tag.removeAll(where: { $0 == selectedName })
             }
            selectedTag = nil
        } else {
            if let previousTag = selectedTag {
                webService.tag.removeAll(where: { $0 == previousTag.name })
            }
            selectedTag = tag
            webService.tag.append(selectedTag?.name ?? "")
        }
        
        print("Selected cuisine: \(webService.tag)")
    }
}

#Preview {
    CuisineScrollView()
}
