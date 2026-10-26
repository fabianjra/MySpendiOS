//
//  ViewModifiers.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

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
