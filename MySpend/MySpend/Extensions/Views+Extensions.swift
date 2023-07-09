//
//  Views+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

extension View {
    
    /**
     Create a custom placeholder fot TextField.
     
     **Example:**
     ```swift
     @State private var text: String = ""
     
     TextField("", text: $text)
         .placeholder(when: text.isEmpty) {
             Text("Text for placeholder")
                 .foregroundColor(Color.gray)
         }
     ```
     
     - Parameters:
        - closure:Text view.
     
     - Returns: View
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: June 2023
     */
    func placeholder<Content: View>(
        when shouldShow: Bool,
        aligment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: aligment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
