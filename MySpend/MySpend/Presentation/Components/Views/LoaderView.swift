//
//  LoaderView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/9/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: Color.primaryGradiant,
                           startPoint: .leading,
                           endPoint: .trailing)
            .mask(Loader()
                .frame(width: FrameSize.width.loaderFullScreen,
                       height: FrameSize.height.loaderFullScreen,
                       alignment: .center)
            )
        }
    }
}

#Preview {
    ContentContainer {
        LoaderView()
    }
}
