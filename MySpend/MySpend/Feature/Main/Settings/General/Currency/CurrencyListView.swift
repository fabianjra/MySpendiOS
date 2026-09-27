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
                    Toggle(.settingsGeneralOptionShowDecimals,
                           isOn: Binding (
                            get: { UserDefaultsManager.showDecimals },
                            set: { UserDefaultsManager.showDecimals = $0}
                           )
                    )
                    .tint(.accentColor)
                }
                
                Section {
                    rowView(viewModel.localeCurrency) {
                        viewModel.updateCurrencySelected(viewModel.localeCurrency)
                    }
                } header: {
                    Text(.currencyMostUsed)
                }
                
                Section {
                    ForEach(viewModel.currenciesAvailables) { currency in
                        rowView(currency) {
                            viewModel.updateCurrencySelected(currency)
                        }
                    }
                } header: {
                    Text(.currencyAllCurrencies)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(.currencyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchCurrencyList()
        }
        .background(Color.backgroundGradient)
    }
    
    func rowView(_ currency: CurrencyModel, action: @escaping () -> Void) -> some View {
        
        Button {
            action()
        } label: {
            HStack {
                Text(viewModel.currencySymbolType == .symbol ? currency.symbol : currency.currencyCode)
                    .foregroundStyle(Color.secondary)
                
                Text(currency.countryName)
                    .foregroundStyle(Color.primary)
                
                Spacer ()
                
                Image.checkmark
                    .opacity(currency.selected ? 1 : .zero)
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
