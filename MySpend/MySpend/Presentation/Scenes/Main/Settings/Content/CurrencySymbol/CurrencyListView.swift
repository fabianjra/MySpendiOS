//
//  CurrencyListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import SwiftUI

struct CurrencyListView: View {
    
    @StateObject var viewModel = CurrencyListViewModel()
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Currency list",
                            subTitle: "Select the currency to show")
            .padding(.bottom)
            
            Toggle(isOn: $viewModel.useCurrencyCode) {
                TextPlain("Prefer currency code")
            }
            .padding(.horizontal)
            
            ListContainer {
                ForEach(viewModel.currencies) { currency in
                    HStack {
                        TextPlain(currency.countryName, color: Color.textFieldForeground)
                        Spacer()
                        TextPlain(currency.currencySymbol, color: Color.textFieldForeground)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCurrencyList()
        }
        .onChange(of: viewModel.useCurrencyCode) {
            viewModel.fetchCurrencyList()
        }
    }
}

#Preview {
    CurrencyListView()
}
