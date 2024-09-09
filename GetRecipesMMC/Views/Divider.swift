//
//  Divider.swift
//  MyMasterCook
//
//  Created by Vardges Gasparyan on 2022-10-23.
//

import SwiftUI

struct Divider: View {
    var body: some View {

        Rectangle().frame(height: 1)
            .foregroundStyle(.accent)
    }
}

struct Divider_Previews: PreviewProvider {
    static var previews: some View {
        Divider()
    }
}
