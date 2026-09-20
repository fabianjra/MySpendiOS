//
//  AppThemeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/26.
//

import SwiftUI

struct AppThemeView: View {
    
    @State private var appTheme = UserDefaultsManager.appTheme {
        didSet { UserDefaultsManager.appTheme = appTheme }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(AppTheme.allCases) { item in
                    Button {
                        appTheme = item
                    } label: {
                        HStack {
                            Text(item.icon)
                            Text(item.localizedName)
                            
                            Spacer()
                            
                            if appTheme == item {
                                Image.checkmark
                            }
                        }
                    }
                    .foregroundStyle(.textPrimaryForeground)
                }
            }
        }
        .navigationTitle("Apperance")
        .background(Color.backgroundGradient)
    }
}

#Preview {
    NavigationStack {
        AppThemeView()
    }
}
