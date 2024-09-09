//
//  DescriptionView.swift
//  MasterCook
//
//  Created by Vardges Gasparyan on 2023-12-23.
//

import SwiftUI

struct DescriptionView: View {
    
    //    MARK: - PROPERTIES
        
        let recipe: Recipe
        
    //    MARK: - BODY
        
        var body: some View {
            
            Group {
                DisclosureGroup(content: {
                    Divider()
                    VStack{
                        if let convertedText = convertHTMLTagsToClickableLinks(in: recipe.description ?? "") {
                            Text(convertedText.string)
                        }
                    } .font(.system(size: 13))
                }, label: {
                    Image(systemName: "info.circle")
                    Text("Description")
                })
                .foregroundStyle(Color.accentColor)
                .background(
                    Color.clear
                )
            }
            .padding()
            .background(
                Color.white
                    .opacity(0.6)
            )
            .cornerRadius(8)
        }
        
        func convertHTMLTagsToClickableLinks(in text: String) -> NSAttributedString? {
            
            let pattern = "<a\\b[^>]+href=['\"]([^'\"]*)['\"][^>]*>(.*?)</a>"
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
            let attributedString = NSMutableAttributedString(string: text)

            let matches = regex.matches(in: text, options: [], range: nsRange)
            for match in matches.reversed() {
                let linkURLRange = match.range(at: 1)
                let linkTextRange = match.range(at: 2)

                let linkURL = (text as NSString).substring(with: linkURLRange)
                let linkText = (text as NSString).substring(with: linkTextRange)

                let range = Range(linkTextRange, in: text)!
                let linkAttributes: [NSAttributedString.Key: Any] = [
                    .link: URL(string: linkURL)!,
                    .foregroundColor: Color.blue // Adjust link color as needed
                ]
                attributedString.addAttributes(linkAttributes, range: NSRange(range, in: text))
                attributedString.replaceCharacters(in: match.range, with: linkText)
            }

            return attributedString
        }
}

//#Preview {
//    DescriptionView(recipe: Recipe(from: <#any Decoder#>))
//}
