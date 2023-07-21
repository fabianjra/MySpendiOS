//
//  TabViewBackground.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

struct TabViewShape: View {
    var body: some View {
        Color.tabViewBackground
            .clipShape(SemiCircleShape())
            .frame(height: Frames.tabViewHeight)
            .cornerRadius(.infinity)
            .shadow(color: .shadow.opacity(Colors.opacityHalf),
                    radius: Radius.shadow,
                    x: .zero, y: .zero)
            .padding(.horizontal)
            .padding(.bottom)
    }
}

struct TabViewShape_Previews: PreviewProvider {
    static var previews: some View {
        TabViewShape()
    }
}
