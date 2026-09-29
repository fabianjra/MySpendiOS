//
//  CurrencyListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import SwiftUI

struct CurrencyListView: View {
    
    @State var viewModel = CurrencyListViewModel()
    
    var body: some View {
        VStack {
            
            Picker(.currencySymbol, selection: $viewModel.currencySymbolType) {
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
                
                Text(viewModel.currencySymbolType == .symbol ? currency.symbol : currency.currencyCode)
                    .foregroundStyle(Color.secondary)
                
                Text(currency.countryName)
                    .foregroundStyle(Color.primary)
                
                Spacer ()
                
                Image.checkmark
                    .opacity(currency.currencyCode == viewModel.selectedCurrency.currencyCode ? 1 : .zero)
                    .bold()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CurrencyListView()
    }
}
