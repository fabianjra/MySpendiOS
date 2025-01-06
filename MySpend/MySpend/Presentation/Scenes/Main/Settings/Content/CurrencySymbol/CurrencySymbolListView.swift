//
//  CurrencySymbolListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import SwiftUI

struct CurrencySymbolListView: View {
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Currency list",
                            subTitle: "Select the currency to show")
            .padding(.bottom)
            
            TextPlain("Prefer currency code")
            
            ListContainer {
                SectionContainer("Cuyrrency list") {
//                    ForEach(ContentOptions.allCases) { option in
//                        if option.showOption {
//                            HStack {
//                                option.icon
//                                
//                                NavigationLink(option.rawValue, destination: option.view)
//                            }
//                        }
//                    }
                }
            }
        }
    }
}

#Preview {
    CurrencySymbolListView()
}
