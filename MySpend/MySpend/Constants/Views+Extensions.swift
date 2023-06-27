//
//  Views+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
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

/**
 ViewBuilder to modify the frame of a View on base of a validation.
 
 **Example:**
 ```swift
 @State private var text: String = ""
 
 TextField("", text: $text)
     .modifier(frameModifier(active: true, height: 20.0))
 ```
 
 - Parameters:
    - active: Validation for activate or not the new height
    - height: New height value for the view.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: June 2023
 */
struct frameModifier: ViewModifier {
    let active : Bool
    let height: CGFloat
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if active {
            content.frame(height: height)
        } else {
            content
        }
    }
}
