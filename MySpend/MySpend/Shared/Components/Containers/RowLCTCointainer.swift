//
//  RowLCTCointainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/12/24.
//

import SwiftUI

struct RowLCTCointainer<Center: View, Trailing: View>: View {
    
    private let centerContent: () -> Center
    private let trailingContent: () -> Trailing
    
    init(@ViewBuilder centerContent: @escaping () -> Center = { EmptyView() },
         @ViewBuilder trailingContent: @escaping () -> Trailing = { EmptyView() }) {
        
        self.centerContent = centerContent
        self.trailingContent = trailingContent
    }
    
    var body: some View {
        ZStack {
            HStack() {
                Spacer()
            }
            
            centerContent()
            
            HStack {
                Spacer()
                trailingContent()
            }
        }
    }
}

#Preview("Menu sort") {
    RowLCTCointainer {
        
        // CENTER CONTENT:
        Text("Center content")
        
    } trailingContent: {
        
        // TRAILING CONTENT:
        Text("Trailing")
    }
}
