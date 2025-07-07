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
            .cornerRadius(ConstantRadius.corners)
            .padding()
            .shadow(color: .shadow,
                    radius: ConstantRadius.shadow,
                    x: .zero, y: .zero)
    }
}

/**
 Style color for full form view. Must be applied to a VStack, inside a ZStack.
 Padding added to separete components from edges inside container.
 
 **Example:**
 ```swift
 ZStack {
     VStack {
        Text("Form style")
    }
    .modifier(FormStyleSign())
 }
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
 Modify the frame of a View based on a validation.
 
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
 Will reserce space of its size.
 
 **Example:**
 ```swift
 @State var condition: Bool = true
 
 Text("Hello world")
    .modifier(ShowReservesSpace(condition))
 ```
 
 - Parameters:
    - isVisible: Boolean condition.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */
struct ShowReservesSpace: ViewModifier {
    private let isVisible: Bool
    
    init(_ isVisible: Bool) {
        self.isVisible = isVisible
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content.opacity(isVisible ? 1 : .zero)
            .animation(.default, value: isVisible)
    }
}

/**
 This is a view modifier that lets you hide or show views that you usually might not be able to.
 It’s worth mentioning that a view modifier is a super helpful pattern you’d do well to commit to memory.
 
 **Example:**
 ```swift
 @State var condition: Bool = true
 
 Text("Hello world")
    .modifier(Hidden(condition))
 ```
 
 - Parameters:
    - hide: Boolean condition to hide or not hide the view.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: December 2024
 */
struct Hidden: ViewModifier {
    let hide: Bool
    
    init(_ hide: Bool) {
        self.hide = hide
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if hide {
            EmptyView()
        } else {
            content
        }
    }
}

/**
 Lets you ignore safe area in views with condition.
 
 **Example:**
 ```swift
 @State var condition: Bool = true
 
 VStack {
    Color.red
 }
 .modifier(IgnoreSafeArea(condition: condition))
 ```
 
 - Parameters:
    - condition: Boolean condition.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */
struct IgnoreSafeArea: ViewModifier {
    let condition: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        if condition {
            content.ignoresSafeArea()
        } else {
            content
        }
    }
}

/**
 Lets you add the background radial radient color to views with condition.
 
 **Example:**
 ```swift
 @State var condition: Bool = true
 
 VStack {
    Color.red
 }
 .modifier(addRadialGradientBackGround(condition: addBackground,
                                       color: Color.backgroundContentGradient))
 ```
 
 - Parameters:
    - condition: Boolean condition.
    - color: Gradient radial color.
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Aug 2024
 */
struct addRadialGradientBackGround: ViewModifier {
    let condition: Bool
    let color: RadialGradient
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        if condition {
            content.background(color)
        } else {
            content
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

/**
 This `ViewModifier` adds a toolbar above the keyboard that allows users to navigate between text fields or dismiss the keyboard by tapping a "Done" button.
 
 The toolbar contains two buttons:
 - One to navigate to the previous text field (if applicable).
 - One to navigate to the next text field (if applicable).
 
 It utilizes a generic `Field` that conforms to both `Hashable` and `CaseIterable`, which means it works with enums representing form fields, providing a way to move between the fields dynamically.
 
 The modifier handles the logic for enabling or disabling the "Next" and "Previous" buttons based on the current focused field's position in the `allCases` sequence.

 **Example:**
 ```swift
 struct ContenidoView: View {
     @FocusState private var focusedField: Login.Field?
     
     var body: some View {
         Form {
             TextField("Email", text: $email)
                 .focused($focusedField, equals: .email)
             
             TextField("Password", text: $password)
                 .focused($focusedField, equals: .password)
         }
         .addKeyboardToolbar(focusedField: $focusedField)
     }
 }
```
 
 - Parameters:
    - focusedField: A FocusState binding that tracks the currently focused text field. It uses an enum representing the form fields.
 
 - Authors: Fabian Rodriguez

 - Version: 1.0

 - Date: September 2024
 */
struct AddKeyboardToolbar<Field: Hashable & CaseIterable>: ViewModifier {
    
    var focusedField: FocusState<Field?>.Binding

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {

                        // Go to previus textfield
                        Button {
                            focusedField.wrappedValue = focusedField.wrappedValue?.previous
                        } label: {
                            Image.chevronUp
                        }
                        .disabled(focusedField.wrappedValue == Field.allCases.first)

                        // Go to next textfield
                        Button {
                            focusedField.wrappedValue = focusedField.wrappedValue?.next
                        } label: {
                            Image.chevronDown
                        }
                        
                        /*
                         A generic type like Field in the ViewModifier cannot inherit from Array or automatically have access to array properties (.first, .last, etc.) just by conforming to CaseIterable.
                         This is because allCases is a sequence (AllCases), not an array.
                         
                         However, a close alternative is to convert the sequence into an array within the ViewModifier.
                         This gives access to the array properties that are needed.
                         By doing so, it allows efficient access to .first and .last, and can be encapsulated within the modifier.
                         */
                        .disabled(focusedField.wrappedValue == Array(Field.allCases).last)

                        Spacer()

                        // Close keyboard
                        Button("Done") {
                            focusedField.wrappedValue = nil
                        }
                    }
                }
            }
    }
}
