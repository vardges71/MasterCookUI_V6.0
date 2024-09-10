//
//  SettingsRowView.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-09-10.
//

import SwiftUI

struct SettingsRowView: View {
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil

    var body: some View {
      VStack {
        Divider().padding(.vertical, 4)
        
        HStack {
            Text(name).foregroundStyle(.accent).opacity(0.5)
          Spacer()
          if (content != nil) {
              Text(content!).foregroundStyle(.accent)
          } else if (linkLabel != nil && linkDestination != nil) {
            Link(linkLabel!, destination: URL(string: "https://\(linkDestination!)")!)
              Image(systemName: "arrow.up.right.square").foregroundStyle(.tabbarBadge)
          }
          else {
            EmptyView()
          }
        }
      }
    }
}

#Preview {
    SettingsRowView(name: "Vardges Gasparyan")
}
