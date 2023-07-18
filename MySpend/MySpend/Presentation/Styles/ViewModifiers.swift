//
//  ViewModifiers.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

/**
 Style color and shape for forms. Must be used in ZStack
 
 **Example:**
 ```swift
 ZStack {
     Color.background
         .ignoresSafeArea()
     
     VStack {
        Text("Form style")
    }
 }
 .modifier(FormStyle())
 ```
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */
struct FormStyleBordered: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(colors: Color.backgroundFormGradiant,
                                       startPoint: .leading,
                                       endPoint: .trailing))
            .cornerRadius(Radius.corners)
            .padding()
            .shadow(color: .shadow,
                    radius: Radius.shadow,
                    x: .zero, y: .zero)
    }
}

/**
 Style color for full form view. Must be used in ZStack.
 Padding added to separete components from edges.
 
 **Example:**
 ```swift
 ZStack {
     VStack {
        Text("Form style")
    }
 }
 .modifier(FormStyleSign())
 ```
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */
struct FormStyleSign: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        Spacer()
            .ignoresSafeArea()
            .background(LinearGradient(colors: Color.backgroundFormGradiant,
                                       startPoint: .leading,
                                       endPoint: .trailing))
        content
            .padding()
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

/**
 This is a view modifier that lets you show or hide views that you usually might not be able to.
 It’s worth mentioning that a view modifier is a super helpful pattern you’d do well to commit to memory.
 
 **Example:**
 ```swift
 @State var condition: Bool = true
 
 Text("Hello world")
    .modifier(Show(isVisible: condition))
 ```
 
 - Parameters:
    - isVisible: Boolean condition.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */
struct Show: ViewModifier {
    let isVisible: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        if isVisible {
            content.opacity(1)
        } else {
            content.opacity(.zero)
        }
    }
}

/**
 Now that we know that the GeometryReader gives us the size of the container, the usual follow-up question is: how do I use it to get the size of a specific view?
 To do this we need to move the geometry reader one level below our targeted view. How? We could add an empty background that gets the size of the targeted view and sends this information back to a Binding.
 Let's create a SizeCalculator ViewModifier so that we can use this functionality on every view:
 
 **Example:**
 ```swift
 extension View {
     func saveSize(in size: Binding<CGSize>) -> some View {
         modifier(SizeCalculator(size: size))
     }
 }
 ```
 
 - Parameters:
    - size: Size to get from a view.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */

struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear //We just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}
