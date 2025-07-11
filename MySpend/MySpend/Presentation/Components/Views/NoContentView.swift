//
//  NoContentView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct NoContentView: View {
    
    var title: String = "Empty"
    var message: String = "Go to settings to add a new"
    var entity: String = "item"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextPlain(title,
                          family: .semibold,
                          size: .bigXL,
                          aligment: .center)
                .padding(.vertical)
                Spacer()
            }
            
            TextPlain("\(message) \(entity)",
                      size: .big,
                      aligment: .center,
                      lineLimit: ConstantViews.messageMaxLines)
            .padding(.bottom)

            Spacer()
        }
    }
}

#Preview {
    VStack {
        NoContentView()
            .background(Color.backgroundBottom)
    }
}
