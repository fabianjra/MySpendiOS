//
//  DividerView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct DividerView: View {
    
    var height: CGFloat = ConstantFrames.dividerHeight
    var maxWidth: CGFloat = ConstantFrames.iPadMaxWidth
    
    var body: some View {
        Divider()
            .frame(height: height)
            .frame(maxWidth: maxWidth)
            .overlay(Color.divider)
    }
}

#Preview {
    ZStack {
        Color.backgroundBottom
        
        DividerView()
    }
}
