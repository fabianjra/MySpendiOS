//
//  TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TransactionView: View {
    
    @StateObject private var viewModel = TransactionViewModel()
    
    //MARK: VIEW PROPERTIES
    @State private var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    @State private var selectedDate: Date = .now
    @State private var searchText: String = ""
    
    // MARK: NAVIGATION
    @State private var showNewTransactionModal = false
    @State private var showSettings = false
    @State private var navigateToHistory: Bool = false
    
    var body: some View {
        VStack {
            
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
                
                Button {
                    showSettings = true
                } label: {
                    Image.settingsFill
                        .resizable()
                        .frame(width: ConstantFrames.navigationBarIcon,
                               height: ConstantFrames.navigationBarIcon)
                        .padding(ConstantViews.paddingNavigationBarIcon)
                    //.foregroundStyle(Color.buttonForeground)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                
                //TODO: Agregar boton para filtrar Accounts. A la derecha del nombre del usuario
            }
            
            
            // MARK: - HISTORY BUTTON
            
            VStack {
                NavigationLink {
                    TransactionHistoryView(transactionsLoaded: $viewModel.transactions,
                                           dateTimeInterval: $dateTimeInterval,
                                           selectedDate: $selectedDate,
                                           isMutipleAccounts: $viewModel.isMutipleAccounts)
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
                        //.padding(.bottom, ConstantViews.paddingBottomResumeview)
                    
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
        .onAppear {
            /// Disable Swipe to go back when ResumeView is showing.
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
        
        .padding(.horizontal)
        .background(Color.backgroundContentGradient)
        
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showNewTransactionModal) {
            AddModifyTransactionView(selectedDate: selectedDate)
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        UserDefaultsManager.userDefaults = .preview
        UserDefaultsManager.userName = "Preview pruebas"
    }
    
    var body: some View { TransactionView() }
}

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper()
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}

#Preview("Saturated \(Previews.localeEN_US)") {
    NavigationStack {
        previewWrapper(.saturated)
            .environment(\.locale, .init(identifier: Previews.localeEN_US))
    }
}

#Preview("Empty \(Previews.localeES_ES)") {
    NavigationStack {
        previewWrapper(.empty)
            .environment(\.locale, .init(identifier: Previews.localeES_ES))
    }
}
