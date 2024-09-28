//
//  ToolBarPrintButton.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2024-09-28.
//

import SwiftUI

struct ToolBarPrintButton: View {
    
    let selectedRecipe: Recipe
    
    var body: some View {
        
        Button {
            
            printInstruction(text: "\(selectedRecipe.name)\n\nDESCRIPTION:\n\(String(describing: selectedRecipe.description))\n\nINSTRUCTION:\n\(selectedRecipe.instructions)")
            
        } label: {
            VStack {
                Image(systemName: "printer")
                Text("print")
                    .font(.caption)
            }
            .foregroundStyle(Color.accentColor)
        }
    }
    
    private func printInstruction(text: String) {
        
        let textWithNewCarriageReturns = text.replacingOccurrences(of: "\n", with: "<br />")
        let printController = UIPrintInteractionController.shared
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printController.printInfo = printInfo
        
        let format = UIMarkupTextPrintFormatter(markupText: textWithNewCarriageReturns)
        
        format.perPageContentInsets.top = 30
        format.perPageContentInsets.bottom = 72
        format.perPageContentInsets.left = 50
        format.perPageContentInsets.right = 30
        printController.printFormatter = format
        
        printController.present(animated: true, completionHandler: nil)
    }
}

//#Preview {
//    ToolBarPrintButton()
//}
