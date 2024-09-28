//
//  AboutTextView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct AboutTextView: View {
    
    var body: some View {
        
        ScrollView {
            Text( LoadAboutText().loadAboutText(file: "AboutMyMasterCook") )
                .font(.footnote)
        } .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .foregroundStyle(Color.accentColor)
            .background(.yellowbutton)
    }
}

#Preview {
    AboutTextView()
}
