//
//  RowLCTCointainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/12/24.
//

import SwiftUI

struct RowLCTCointainer<Leading: View, Center: View, Trailing: View>: View {
    
    private let disabled: Bool
    
    private let leadingContent: () -> Leading
    private let centerContent: () -> Center
    private let trailingContent: () -> Trailing
    
    init(disabled: Bool = false,
         @ViewBuilder leadingContent: @escaping () -> Leading = { EmptyView() },
         @ViewBuilder centerContent: @escaping () -> Center = { EmptyView() },
         @ViewBuilder trailingContent: @escaping () -> Trailing = { EmptyView() }) {
        
        self.disabled = disabled
        
        self.leadingContent = leadingContent
        self.centerContent = centerContent
        self.trailingContent = trailingContent
    }
    
    var body: some View {
        ZStack {
            HStack() {
                leadingContent()
                Spacer()
            }
            
            centerContent()
            
            HStack {
                Spacer()
                trailingContent()
            }
        }
        .disabled(disabled)
    }
}

#Preview("Menu sort") {
    RowLCTCointainer {
        
        //LEADING CONTENT:
        TextPlain("Leading")
        
    } centerContent: {
        
        // CENTER CONTENT:
        TextPlain("Center content")
        
    } trailingContent: {
        
        // TRAILING CONTENT:
        TextPlain("Trailing")
    }
    .background(Color.backgroundBottom)
}
