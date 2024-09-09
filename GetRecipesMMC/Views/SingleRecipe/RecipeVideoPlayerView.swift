//
//  RecipeVideoPlayerView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2023-12-23.
//

import SwiftUI
import AVKit

struct RecipeVideoPlayerView: View {
    
    
    //    MARK: - PROPERTIES
    
    var selectedRecipe: Recipe
    
    @State private var player: AVPlayer?
    
    //    MARK: - BODY
    var body: some View {
        
        VStack {
            VideoPlayer(player: player)
                .onAppear() {
                    // Start the player going, otherwise controls don't appear
                    guard let url = URL(string: selectedRecipe.videoURL ?? "") else {
                        return
                    }
                    let player = AVPlayer(url: url)
                    self.player = player
                    
                    player.play()
                }
                .onDisappear() {
                    // Stop the player when the view disappears
                    player?.pause()
                }
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
        } // VStack
    }
}

//#Preview {
//    RecipeVideoPlayerView(selectedRecipe: Recipe())
//}
