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
            
            
            Toggle(isOn: $viewModel.useCurrencySymbol) {
                TextPlain("Prefer currency symbol")
            }
            .padding(.horizontal)
            
            
            ListContainer {
                
                if var localeCurrency = viewModel.localeCurrency {
                    SectionContainer("Preferred currencies", isInsideList: true) {
                        rowView(localeCurrency) {
                            viewModel.selectCurrencySymbol(viewModel.useCurrencySymbol ? localeCurrency.symbol : localeCurrency.currencyCode)
                            //localeCurrency.selected = true //TODO: Hacer logica
                        }
                            .listRowBackground(Color.listRowBackground)
                    }
                }
                
                
                SectionContainer("Available currencies", isInsideList: true) {
                    ForEach(viewModel.currenciesAvailables) { currency in
                        rowView(currency) {
                            viewModel.selectCurrencySymbol(viewModel.useCurrencySymbol ? currency.symbol : currency.currencyCode)
                            //currency.selected = true //TODO: Hacer logica
                        }
                    }
                    .listRowBackground(Color.listRowBackground)
                }
            }
        }
        .onAppear {
            viewModel.fetchCurrencyList()
        }
    }
    
    func rowView(_ currency: CurrencyModel, action: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: currency.selected ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FrameSize.height.selectIconInsideTextField,
                       height: FrameSize.width.selectIconInsideTextField)
                .foregroundStyle(currency.selected ? Color.primaryLeading : Color.textFieldPlaceholder)
                .transition(.scale.combined(with: .move(edge: .leading)))
            
            Button {
                action()
            } label: {
                TextPlain(currency.countryName, color: Color.textFieldForeground)
            }
            
            Spacer()
            
            TextPlain(viewModel.useCurrencySymbol ? currency.symbol : currency.currencyCode, color: Color.textFieldForeground)
        }
    }
}

#Preview {
    CurrencyListView()
}
