//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            TabViewMain()
        }
        .onAppear {
            UIApplication.shared.addTapGestureRecognizer()
        }
    }
}

#Preview {
    RootView()
}
