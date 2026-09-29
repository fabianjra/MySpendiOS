//
//  CurrencyListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import SwiftUI

struct CurrencyView: View {
    
    @State var viewModel = CurrencyViewModel()
    
    var body: some View {
        VStack {
            
            Picker(.currencySymbol, selection: $viewModel.selectedCurrencySymbolType) {
                ForEach(CurrencySymbolType.allCases) { symbolType in
                    Text(symbolType.localized)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                Section {
                    Toggle(.currencyShowCents,
                           isOn: Binding (
                            get: { UserDefaultsManager.showDecimals },
                            set: { UserDefaultsManager.showDecimals = $0}
                           )
                    )
                    .tint(.accentColor)
                }
                
                Section {
                    rowView(viewModel.localeCurrency)
                } header: {
                    Text(.currencyMostUsed)
                }
                
                Section {
                    ForEach(viewModel.currenciesAvailables) { currency in
                        rowView(currency)
                    }
                } header: {
                    Text(.currencyAllCurrencies)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(.currencyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.backgroundGradient)
    }
    
    private func rowView(_ currency: CurrencyModel) -> some View {
        Button {
            viewModel.selectedCurrency = currency
        } label: {
            HStack {
                Text(currency.countryFlag)
                
                Text(viewModel.selectedCurrencySymbolType == .symbol ? currency.symbol : currency.currencyCode)
                    .foregroundStyle(Color.secondary)
                
                Text(currency.countryName)
                    .foregroundStyle(Color.primary)
                
                Spacer ()
                
                if currency.countryCode == viewModel.selectedCurrency.countryCode {
                    Image.checkmark
                        .bold()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CurrencyView()
    }
}
