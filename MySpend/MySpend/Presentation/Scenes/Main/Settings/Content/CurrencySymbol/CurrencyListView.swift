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
            
            Button("Reset currency symbol selected") {
                viewModel.resetCurrencySymbol()
            }
            .buttonStyle(ButtonLinkStyle(color: Color.alert))
            .padding(.horizontal)
            
            ListContainer {
                ForEach(viewModel.currencies) { currency in
                    HStack {
                        TextPlain(currency.countryName, color: Color.textFieldForeground)
                        //Spacer()
                        Button {
                            viewModel.selectCurrencySymbol(currency.currencySymbol)
                        } label: {
                            //
                        }

                        TextPlain(currency.currencySymbol, color: Color.textFieldForeground)
                    }
                }
                .listRowBackground(Color.listRowBackground)
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
