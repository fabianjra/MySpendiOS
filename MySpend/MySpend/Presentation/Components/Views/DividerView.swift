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
            .frame(height: Frames.dividerHeight)
            .overlay(Color.divider)
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.background
            
            DividerView()
        }
        
    }
}
