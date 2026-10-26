//
//  Views+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

extension View {
    
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
