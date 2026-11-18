//
//  TransactionForm.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/11/26.
//

import SwiftUI

struct TransactionForm: View {
    
    @Environment(AccountManager.self) private var accountManager
    @Environment(CurrencyManager.self) private var currencyManager
    
    // PARAMETRIZADOS
    @Binding var transaction: TransactionModel
    @Binding var type: CategoryType
    @Binding var amountString: String
    
    let onConfirm: () -> Void
    var onDelete: (() -> Void)? = nil
    
    @FocusState private var isNoteFocused: Bool
    
    private var showAccountTextField: Bool {
        accountManager.sortedAccounts.count > 1
    }
    
    @State private var feedbackTrigger = 0
    
    //SHEETS
    @State private var showDatePicker = false
    @State private var showCategoryList = false
    @State private var showAccountList = false
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CategoryPickerView(selection: $type)
                    .glassEffect(.regular)
                    .padding(.horizontal)
                
                
                HStack {
                    Button {
                        feedbackTrigger += 1
                        transaction.favorite.toggle()
                    } label: {
                        Image(systemName: transaction.favorite ? ConstantSystemImage.favoriteFill : ConstantSystemImage.favorite)
                            .foregroundStyle(transaction.favorite ? Color.accentColor : Color.secondary)
                            .padding(ConstantViews.highSpacing)
                            .contentShape(Circle())
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.plain)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                    }
                    .accessibilityLabel(Text(.favoriteMarkFavorite))
                    .accessibilityAddTraits(transaction.favorite ? [.isSelected] : [])
                    
                    
                    if showAccountTextField {
                        Button {
                            showAccountList = true
                        } label: {
                            Label {
                                if transaction.account.name.isEmptyOrWhiteSpace {
                                    Text(.transactionInputAccountPlaceholder)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text(transaction.account.name)
                                }
                            } icon: {
                                if transaction.account.name.isEmptyOrWhiteSpace {
                                    Image(systemName: ConstantSystemImage.selectAccount)
                                } else {
                                    Image(systemName: transaction.account.icon)
                                }
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .padding(ConstantViews.highSpacing)
                        }
                        .buttonStyle(.plain)
                        .overlay {
                            Capsule()
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                HStack(alignment: .top, spacing: ConstantViews.minimumSpacing) {
                    Text(currencyManager.selectedSymbolOrCode)
                        .font(.system(size: 23, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .offset(y: 5)
                    
                    Text(amountString.isEmpty ? Int.zero.description : amountString)
                        .contentTransition(.numericText())
                        .animation(.default, value: amountString)
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                        .textSelection(.enabled)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal)
                
                
                Spacer()
                
                
                VStack {
                    
                    HStack {
                        Button {
                            showDatePicker = true
                        } label: {
                            Label {
                                if Calendar.current.isDateInToday(transaction.dateTransaction) {
                                    HStack {
                                        Text(.dateToday)
                                        
                                        Text(transaction.dateTransaction.toStringShortLocaleNoYear)
                                    }
                                } else {
                                    if Calendar.current.isDate(transaction.dateTransaction, equalTo: .now, toGranularity: .year) {
                                        Text(transaction.dateTransaction.toStringShortLocaleNoYear)
                                    } else {
                                        Text(transaction.dateTransaction.toStringShortLocale)
                                    }
                                }
                            } icon: {
                                Image.calendar
                            }
                            .padding(ConstantViews.highSpacing)
                        }
                        .buttonStyle(.plain)
                        .background {
                            Capsule()
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        }
                        
                        
                        HStack(spacing: ConstantViews.mediumSpacing) {
                            Image(systemName: ConstantSystemImage.notes)
                                .foregroundStyle(transaction.notes.isEmptyOrWhiteSpace ? .secondary : .primary)
                            
                            TextField(.transactionInputNotesPlaceholder, text: $transaction.notes)
                                .lineLimit(1)
                                .focused($isNoteFocused)
                                .submitLabel(.done)
                                .formInputStyle($transaction.notes)
                        }
                        .padding(ConstantViews.highSpacing)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    
                    HStack {
                        Button {
                            showCategoryList = true
                        } label: {
                            Label {
                                if transaction.category.name.isEmptyOrWhiteSpace {
                                    Text(.transactionInputCategoryPlaceholder)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text(transaction.category.name)
                                }
                            } icon: {
                                if transaction.category.name.isEmptyOrWhiteSpace {
                                    Image(systemName: ConstantSystemImage.selectCategory)
                                } else {
                                    Image(systemName: transaction.category.icon)
                                }
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .padding(ConstantViews.highSpacing)
                        }
                        .buttonStyle(.plain)
                        .overlay {
                            Capsule()
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading)
                }
                
                
                TransactionNumberPad(
                    onDigit: { digit in
                        feedbackTrigger += 1
                        amountString = onChangeAmount(amountString + digit)
                        
                    }, onDecimal: {
                        feedbackTrigger += 1
                        
                        let separator = CurrencyConstant.localDecimalSeparator
                        guard !amountString.contains(separator) else { return }
                        
                        amountString = onChangeAmount(amountString + separator)
                        
                    }, onErase: {
                        feedbackTrigger += 1
                        
                        guard !amountString.isEmpty else { return }
                        
                        amountString.removeLast()
                        amountString = onChangeAmount(amountString)
                        
                    }, onClear: {
                        feedbackTrigger += 1
                        amountString = ""
                    },
                    onConfirm: onConfirm,
                    onDelete: onDelete
                )
                .padding(.horizontal)
            }
            
            // MARK: EVENTS
            
            .onAppear {
                amountString = onChangeAmount(amountString, prepareForAppear: true)
            }
            .onChange(of: accountManager.sortedAccounts, initial: true) {
                configureSelectedAccount()
            }
            .onChange(of: type) { _, newValue in
                transaction.category = CategoryModel(type: newValue)
            }
            
            
            // MARK: SHEETS
            
            .sheet(isPresented: $showDatePicker) {
                DatePickerModalView(selectedDate: $transaction.dateTransaction)
            }
            .sheet(isPresented: $showCategoryList) {
                NavigationStack {
                    SelectCategoryView(selectedCategory: $transaction.category, type: $type)
                }
            }
            .sheet(isPresented: $showAccountList) {
                NavigationStack {
                    SelectAccountView(selectedAccount: $transaction.account)
                }
            }
            
            .sensoryFeedback(.selection, trigger: feedbackTrigger)
            
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func configureSelectedAccount() {
        let accounts = accountManager.sortedAccounts
        
        guard !accounts.isEmpty else { return }
        
        // Preserve the existing account if it is still available.
        if let selectedAccount = accounts.first(where: { $0.id == transaction.account.id }) {
            transaction.account = selectedAccount
            return
        }
        
        // Otherwise, select the default account or the first available.
        transaction.account = accounts.first { $0.id == accountManager.defaultAccount?.id } ?? accounts[0]
    }
    
    /**
     Validates and formats the amount while typing.
     
     When preparing the initial value, removes unnecessary decimal zeros
     while preserving significant fractional digits.
     */
    private func onChangeAmount(_ text: String, prepareForAppear: Bool = false) -> String {
        let decimalSeparator = CurrencyConstant.localDecimalSeparator
        let groupingSeparator = CurrencyConstant.localGroupingSeparator
        
        let cleanedText = text.replacingOccurrences(of: groupingSeparator, with: "")
        let parts = cleanedText.components(separatedBy: decimalSeparator)
        
        let integerPart = String(parts[0].filter(\.isASCII).filter(\.isNumber).prefix(CurrencyConstant.amoutMaxLength))
        let decimalPart = String(parts.dropFirst().joined().filter(\.isASCII).filter(\.isNumber).prefix(CurrencyConstant.fractionLength))
        
        guard !integerPart.isEmpty || parts.count > 1 else {
            return ""
        }
        
        if prepareForAppear && (decimalPart.isEmpty || decimalPart.allSatisfy({ $0 == "0" })) {
            return integerPart == "0" ? "" : onChangeAmount(integerPart)
        }
        
        let integerValue = Decimal(string: integerPart) ?? .zero
        let formatter = CurrencyConstant.localFormatter(showCents: false)
        let formattedInteger = formatter.string(from: NSDecimalNumber(decimal: integerValue)) ?? integerPart
        
        guard parts.count > 1 else {
            return formattedInteger
        }
        
        return formattedInteger + decimalSeparator + decimalPart
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var accountManager = AccountManager(viewContext: MockDataType.normal.viewContext)
    @Previewable @State var categoryManager = CategoryManager(viewContext: MockDataType.normal.viewContext)
    
    @Previewable @State var currencyManager = CurrencyManager.shared
    
    @Previewable @State var transaction = TransactionModel()
    @Previewable @State var type = CategoryType.expense
    @Previewable @State var amountString = ""
    
    TransactionForm(transaction: $transaction, type: $type, amountString: $amountString) { }
        .environment(accountManager)
        .environment(categoryManager)
        .environment(currencyManager)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    
    @Previewable @State var accountManager = AccountManager(viewContext: MockDataType.normal.viewContext)
    @Previewable @State var categoryManager = CategoryManager(viewContext: MockDataType.normal.viewContext)
    
    @Previewable @State var currencyManager = CurrencyManager.shared
    
    @Previewable @State var transaction = TransactionModel()
    @Previewable @State var type = CategoryType.expense
    @Previewable @State var amountString = ""
    
    TransactionForm(transaction: $transaction, type: $type, amountString: $amountString) { }
        .environment(accountManager)
        .environment(categoryManager)
        .environment(currencyManager)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
