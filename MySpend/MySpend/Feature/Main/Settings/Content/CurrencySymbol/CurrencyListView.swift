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
            
            
            Picker("Currency", selection: $viewModel.currencySymbolType) {
                ForEach(CurrencySymbolType.allCases) { type in
                    TextPlain(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            

            ListContainer {
                
                SectionContainer("Preferred currencies", isInsideList: true) {
                    rowView(viewModel.localeCurrency) {
                        viewModel.updateCurrencySelected(viewModel.localeCurrency)
                    }
                }
                
                SectionContainer("Available currencies", isInsideList: true) {
                    ForEach(viewModel.currenciesAvailables) { currency in
                        rowView(currency) {
                            viewModel.updateCurrencySelected(currency)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCurrencyList()
        }
        .onChange(of: viewModel.currencySymbolType) {
            viewModel.updateCurrencySymbolTypeSelected()
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
            
            TextPlain(viewModel.currencySymbolType == .symbol ? currency.symbol : currency.currencyCode, color: Color.textFieldForeground)
        }
    }
}

#Preview {
    CurrencyListView()
}
