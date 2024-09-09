//
//  ToolBarPlayButton.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2023-12-23.
//

import SwiftUI

struct ToolBarPlayButton: View {

    //    MARK: - PROPERTIES
    
    let selectedRecipe: Recipe
    
    @State private var isPresented: Bool = false
    @State private var isShowVideoAlert: Bool = false
    
    //    MARK: - BODY
    var body: some View {
        VStack {
            Button {
                
                if selectedRecipe.videoURL == "" {
                    isShowVideoAlert.toggle()
                } else {
                    isPresented.toggle()
                }
            } label: {
                VStack {
                    Image(systemName: "play")
                    Text("play video")
                        .font(.caption)
                }
                .foregroundStyle(Color.accentColor)
            }
        } // VStack
        .sheet(isPresented: $isPresented) { RecipeVideoPlayerView(selectedRecipe: selectedRecipe) }

        .actionSheet(isPresented: $isShowVideoAlert) {
            ActionSheet(
                title: Text("SORRY..."), message: Text("The video instruction does not exist."),
                buttons: [ .default(Text("OK")) ]
            )
        }
    }
}

//#Preview {
//    ToolBarPlayButton(selectedRecipe: Recipe())
//}
