//
//  Views+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        aligment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: aligment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
            .padding(.vertical) //Add padding when placeholder is empty.
        }
}
