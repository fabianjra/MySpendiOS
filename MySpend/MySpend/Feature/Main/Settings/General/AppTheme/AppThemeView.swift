//
//  AppThemeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/26.
//

import SwiftUI

struct AppThemeView: View {
    @Environment(ThemeManager.self) private var themeManager
    
    var body: some View {
        VStack {
            List {
                ForEach(AppTheme.allCases) { item in
                    Button {
                        themeManager.theme = item
                    } label: {
                        HStack {
                            Text(item.icon)
                            Text(item.localizedName)
                            
                            Spacer()
                            
                            if themeManager.theme == item {
                                Image.checkmark
                            }
                        }
                    }
                    .foregroundStyle(.textPrimaryForeground)
                }
            }
        }
        .navigationTitle(.appThemeViewTitle)
        .background(Color.backgroundGradient)
    }
}

#Preview {
    @Previewable @State var themeManager = ThemeManager.shared
    
    NavigationStack {
        AppThemeView()
            .environment(themeManager)
            .preferredColorScheme(themeManager.theme.colorScheme)
    }
}
