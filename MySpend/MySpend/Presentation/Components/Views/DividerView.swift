//
//  DividerView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Divider()
            .frame(height: ConstantFrames.dividerHeight)
            .overlay(Color.divider)
    }
}

#Preview {
    ZStack {
        Color.backgroundBottom
        
        DividerView()
    }
}
