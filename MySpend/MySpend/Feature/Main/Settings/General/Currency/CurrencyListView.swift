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
        .onAppear {
            viewModel.fetchCurrencyList()
        }
        .background(Color.backgroundGradient)
    }
    
    func rowView(_ currency: CurrencyModel, action: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: currency.selected ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FrameSize.height.iconRowList,
                       height: FrameSize.width.iconRowList)
                .foregroundStyle(currency.selected ? .accentColor : Color.textFieldPlaceholder)
                .transition(.scale.combined(with: .move(edge: .leading)))
            
            Button {
                action()
            } label: {
                Text(currency.countryName)
            }
            
            Spacer()
            
            Text(viewModel.currencySymbolType == .symbol ? currency.symbol : currency.currencyCode)
        }
    }
}

#Preview {
    NavigationStack {
        CurrencyListView()
    }
}
