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
    
    /**
     Assign corners to a view, selecting especific corners.
     
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
        - radius:How much de corner will be. | .inifinity value by default.
        - corners:Which corners will curve. | .allCorners value by default.
     
     - Returns: View
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: June 2023
     */
    func cornerRadiusCustom(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCornerShape(radius: radius, corners: corners) )
    }
    
    /**
     The job of the SizeCalculator is to add a GeometryReader as the background of our target view.
     On appear, so after SwiftUI has rendered the content, it will send the size back to the Binding
     
     Reference: https://stackoverflow.com/questions/57577462/get-width-of-a-view-using-in-swiftui
     
     **Example:**
     ```swift
     struct SomeView: View {
         
         @State var size: CGSize = .zero
         
         var body: some View {
             VStack {
                 Text("text width: \(size.width)")
                 Text("text height: \(size.height)")
                 
                 Text("hello")
                     .saveSize(in: $size)
             }
             
         }
     }
     ```
     
     - Parameters:
        - size:size to get width or height from a view.
     
     - Returns: View
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: July 2023
     */
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
    
    /**
     Run just the first time an specific code in a View.
     
     Reference: https://stackoverflow.com/a/72561065/7116544
     
     **Example:**
     ```swift
     struct SomeView: View {
         
        @Text("Hello World")
            .onFirstAppear {
                /* The code here only runs on the first appear */
            }
     }
     ```
     
     - Parameters:
        - action:Action to excecute
     
     - Returns: View
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: October 2024
     */
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }
}


private struct ViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void

    init(perform action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            action()
        }
    }
}
