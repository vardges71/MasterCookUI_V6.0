//
//  SettingsLabelView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct SettingsLabelView: View {
    
    var labelText: String
    var labelImage: String

    var body: some View {
      HStack {
        Text(labelText.uppercased()).fontWeight(.bold)
        Spacer()
        Image(systemName: labelImage)
      }
      .foregroundStyle(.accent)
      .font(.title3)
      .fontDesign(.rounded)
    }
}

#Preview {
    SettingsLabelView(labelText: "MyMasterCook", labelImage: "info.circle")
}
