//
//  TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TransactionView: View {
    
    @StateObject var viewModel = TransactionViewModel()
    
    @State var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    @Binding var selectedDate: Date
    
    var body: some View {
        ContentContainer {
            
            // MARK: - HEADER
            
            HStack {
                VStack(alignment: .leading) {
                    TextPlainLocalized(textLocalized: "greet \(viewModel.userName) \(Emojis.greeting.rawValue)",
                                        table: LocalizableTable.user,
                                        family: .semibold,
                                        size: .big,
                                        lineLimit: ConstantViews.singleTextMaxLines,
                                        truncateMode: .tail)
                    
                    TextPlainLocalized(Localizable.User.welcome,
                                        family: .light,
                                        size: .small,
                                        lineLimit: ConstantViews.singleTextMaxLines)
                }
                Spacer()
                
                //TODO: Agregar boton para filtrar Accounts. A la derecha del nombre del usuario
            }
            
            
            // MARK: - HISTORY BUTTON
            
            VStack {
                NavigationLink {
                    TransactionHistoryView(transactionsLoaded: $viewModel.transactions,
                                           dateTimeInterval: $dateTimeInterval,
                                           selectedDate: $selectedDate,
                                           isMutipleAccounts: $viewModel.isMutipleAccounts)
                    .toolbar(.hidden, for: .navigationBar) //TODO: Quitar el navegador.
                } label: {
                    TextButtonHorizontalStyled(Localizable.Button.history.key,
                                               subTitle: Localizable.Button.history_subtitle.key,
                                               iconLeading: Image.stackFill,
                                               iconTrailing: Image.arrowRight)
                }
            }
            
            
            // MARK: - TRANSACTIONS
            
                if viewModel.transactions.isEmpty {
                    NoContentToAddView()
                    Spacer()
                } else {
                    VStack {
                        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                                  selectedDate: $selectedDate,
                                                  isEditing: .constant(false)){}
                        
                        let transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
                                                                                          transactions: viewModel.transactions,
                                                                                          for: dateTimeInterval)
                        
                        let groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered)
                            .sorted(by: { $0.totalAmount > $1.totalAmount })
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(groupedTransactions, id:\.category.id) { item in
                                HStack {
                                    TextPlain(item.category.name)
                                    
                                    Spacer()
                                    
                                    TextPlain(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                }
                                .padding(.vertical, ConstantViews.minimumSpacing)
                            }
                        }
                        .animation(.default, value: transactionsFiltered.count)
                        
                        TextError(viewModel.errorMessage)
                        
                        TotalBalanceView(transactions: transactionsFiltered)
                        
                        //TODO: Aplicar wheel de accounts
//                        if viewModel.showAccountFilter {
//                            Picker("Accounts", selection: $viewModel.dateTimeInterval) {
//                                
//                            }.pickerStyle(.wheel)
//                        }
                    }
                    
                    //Tiene un efecto no deseado al transicionar entre tab y tab.
                    //TODO: Revisar si con listener se comporta diferente.
                    //.redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
        }
        .onFirstAppear {
            Task {
                await viewModel.activateObservers()
            }
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        UserDefaultsManager.userDefaults = .preview
        UserDefaultsManager.userName = "Fabian"
    }
    @State var selectedDate = Date()
    var body: some View { TransactionView(selectedDate: $selectedDate) }
}

#Preview("Normal \(Previews.localeES_CR)") {
    previewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Saturated \(Previews.localeEN_US)") {
    previewWrapper(.saturated)
        .environment(\.locale, .init(identifier: Previews.localeEN_US))
}

#Preview("Empty \(Previews.localeES_ES)") {
    previewWrapper(.empty)
        .environment(\.locale, .init(identifier: Previews.localeES_ES))
}
