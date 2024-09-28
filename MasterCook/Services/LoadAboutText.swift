//
//  LoadAboutText.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import Foundation

struct LoadAboutText {

    func loadAboutText(file name:String) -> String {
        
        if let path = Bundle.main.path(forResource: name, ofType: "txt") {

            if let contents = try? String(contentsOfFile: path) {

                return contents

            } else {

                print("Error! - This file doesn't contain any text.")
            }

        } else {

            print("Error! - This file doesn't exist.")
        }

        return ""
    }
}
