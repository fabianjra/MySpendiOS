//
//  CurrencyListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import SwiftUI

struct CurrencyView: View {
    
    @Environment(CurrencyManager.self) private var currencyManager
    
    var body: some View {
        VStack {
            
            @Bindable var currencyManager = currencyManager
            
            Picker(.currencySymbol, selection: $currencyManager.selectedSymbolType) {
                ForEach(CurrencySymbolType.allCases) { symbolType in
                    Text(symbolType.localized)
                }
            }
            .pickerStyle(.segmented)
            .glassEffect(.regular)
            .padding(.horizontal)
            
            List {
                Section {
                    ForEach(CurrencyManager.commonCurrencyList) { currency in
                        rowView(currency)
                    }
                } header: {
                    Text(.currencyMostUsed)
                }
                
                Section {
                    ForEach(CurrencyManager.availableCurrencyList) { currency in
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
            currencyManager.selectedCurrency = currency
        } label: {
            HStack {
                Text(currency.countryFlag)
                
                Text(currencyManager.selectedSymbolType == .symbol ? currency.symbol : currency.currencyCode)
                    .foregroundStyle(Color.secondary)
                
                Text(currency.countryName)
                    .foregroundStyle(Color.primary)
                
                Spacer ()
                
                if currency.countryCode == currencyManager.selectedCurrency.countryCode {
                    Image.checkmark
                }
            }
        }
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var currencyManager = CurrencyManager.shared
    
    NavigationStack {
        CurrencyView()
    }
    .environment(currencyManager)
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    
    @Previewable @State var currencyManager = CurrencyManager.shared
    
    NavigationStack {
        CurrencyView()
    }
    .environment(currencyManager)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
