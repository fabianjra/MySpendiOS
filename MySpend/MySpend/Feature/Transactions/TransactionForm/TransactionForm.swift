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
    
//    var autoFocus: Bool = true
//    @FocusState private var isFocused: Bool
    
    private var showAccountTextField: Bool {
        accountManager.sortedAccounts.count > 1
    }
    
    //SHEETS
    @State private var showDatePicker = false
    @State private var showCategoryList = false
    @State private var showAccountList = false
    
    let onConfirm: () -> Void
    var onDelete: (() -> Void)? = nil

    var body: some View {
        VStack {
            CategoryPickerView(selection: $type)
                .glassEffect(.regular)
                .padding(.horizontal)
            
            
            HStack {
                Button {
                    transaction.favorite.toggle()
                } label: {
                    Image(systemName: transaction.favorite ? ConstantSystemImage.favoriteFill : ConstantSystemImage.favorite)
                        .font(.callout)
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
                        .font(.callout)
                        .foregroundStyle(Color.primary)
                        .padding(.horizontal, ConstantViews.highSpacing)
                        .padding(.vertical, ConstantViews.highSpacing)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
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
                    //.animation(.snappy, value: amountString)
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .textSelection(.enabled)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity)
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
                        .font(.callout)
                        .foregroundStyle(Color.primary)
                        .padding(.horizontal, ConstantViews.highSpacing)
                        .padding(.vertical, ConstantViews.highSpacing)
                    }
                    .buttonStyle(.plain)
                    //.background {
                    //    Capsule()
                    //        .fill(Color(.secondarySystemGroupedBackground))
                    //}
                    .overlay {
                        Capsule()
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                    }
                    
                    
                    HStack(spacing: ConstantViews.mediumSpacing) {
                        Image(systemName: ConstantSystemImage.notes)
                            .foregroundStyle(.secondary)

                        TextField(.transactionInputNotesPlaceholder, text: $transaction.notes)
                            .font(.callout)
                            .lineLimit(1)
                            .submitLabel(.done)
                            .formInputStyle($transaction.notes, textLimit: 160)
                    }
                    .padding(.horizontal, ConstantViews.highSpacing)
                    .padding(.vertical, ConstantViews.highSpacing)
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
                        .font(.callout)
                        .foregroundStyle(Color.primary)
                        .padding(.horizontal, ConstantViews.highSpacing)
                        .padding(.vertical, ConstantViews.highSpacing)
                        
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
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
                    withAnimation {
                        amountString = onChangeAmount(amountString + digit)
                    }
                    
                }, onDecimal: {
                    withAnimation {
                        let separator = CurrencyConstant.localDecimalSeparator
                        
                        guard !amountString.contains(separator) else { return }
                        
                        amountString = onChangeAmount(amountString + separator)
                    }
                    
                }, onErase: {
                    withAnimation {
                        guard !amountString.isEmpty else { return }
                        
                        amountString.removeLast()
                        amountString = onChangeAmount(amountString)
                    }
                    
                }, onClear: {
                    withAnimation {
                        amountString = ""
                    }
                    
                },
                onConfirm: onConfirm,
                onDelete: onDelete
            )
            .padding(.horizontal)

            
//            Form {
//                Section {
//                    
//                    Button {
//                        showDatePicker = true
//                    } label: {
//                        HStack(spacing: ConstantViews.formLabeledContentSpacing) {
//                            Text(.transactionInputDate)
//                                .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
//                            
//                            Text(transaction.dateTransaction.toStringShortLocale)
//                            
//                            Spacer()
//                            
//                            Image.calendar
//                        }
//                        .foregroundStyle(Color.primary)
//                    }
//                    
//                    
//                    LabeledContent(.transactionInputAmount) {
//                        TextField(.transactionInputAmountPlaceholder, text: $amountString)
//                            .formInputStyle($amountString)
//                            .keyboardType(.decimalPad)
//                            .focused($isFocused)
//                    }
//                    .formLabeledInputStyle
//                    
//                    
//                    Button {
//                        showCategoryList = true
//                    } label: {
//                        HStack(spacing: ConstantViews.formLabeledContentSpacing) {
//                            Text(.transactionInputCategory)
//                                .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
//                                .foregroundStyle(Color.primary)
//                            
//                            if transaction.category.name.isEmptyOrWhiteSpace {
//                                Text(.transactionInputCategoryPlaceholder)
//                                    .foregroundStyle(Color(uiColor: .placeholderText))
//                            } else {
//                                Label(transaction.category.name, systemImage: transaction.category.icon)
//                                    .foregroundStyle(Color.primary)
//                            }
//                        }
//                    }
//                    .alignmentGuide(.listRowSeparatorLeading) { dimensions in
//                        dimensions[.leading]
//                    }
//                    
//                    
//                    if showAccountTextField {
//                        Button {
//                            showAccountList = true
//                        } label: {
//                            HStack(spacing: ConstantViews.formLabeledContentSpacing) {
//                                Text(.transactionInputAccount)
//                                    .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
//                                    .foregroundStyle(Color.primary)
//                                
//                                if transaction.account.name.isEmptyOrWhiteSpace {
//                                    Text(.transactionInputAccountPlaceholder)
//                                        .foregroundStyle(Color(uiColor: .placeholderText))
//                                } else {
//                                    Label(transaction.account.name, systemImage: transaction.account.icon)
//                                        .foregroundStyle(Color.primary)
//                                }
//                            }
//                        }
//                        .alignmentGuide(.listRowSeparatorLeading) { dimensions in
//                            dimensions[.leading]
//                        }
//                    }
//                    
//                    
//                    LabeledContent(.transactionInputNotes) {
//                        TextField(.transactionInputNotesPlaceholder, text: $transaction.notes, axis: .vertical)
//                            .formInputStyle($transaction.notes, textLimit: 160)
//                            .keyboardType(.alphabet)
//                    }
//                    .formLabeledInputStyle
//                    
//                    
//                    Toggle(isOn: $transaction.favorite) {
//                        Text(.favoriteMarkFavorite)
//                    }
//                    .tint(.accentColor)
//                    
//                } footer: {
//                    VStack(alignment: .leading) {
//                        if transaction.category.name.isEmptyOrWhiteSpace {
//                            Text(.transactionInputCategoryRequired)
//                                .foregroundStyle(.alert)
//                        }
//                        
//                        if transaction.account.name.isEmptyOrWhiteSpace {
//                            Text(.transactionInputAccountRequired)
//                                .foregroundStyle(.alert)
//                        }
//                    }
//                }
//            }
//            .scrollContentBackground(.hidden)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        // MARK: EVENTS
        
        .onAppear {
            amountString = onChangeAmount(amountString, prepareForAppear: true)
        }
        // Permite configurar la cuenta cuando carguen en un inicio o cuando aun falta para que CoreData me devuelva las cuentas.
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
        
//    private func onChangeFocusAmount(_ text: String, _ isFocused: Bool) -> String {
//        let decimalSeparator = CurrencyConstant.localDecimalSeparator
//        let groupingSeparator = CurrencyConstant.localGroupingSeparator
//
//        if isFocused {
//            let editableText = text.replacingOccurrences(of: groupingSeparator,with: "")
//
//            let parts = editableText.components(separatedBy: decimalSeparator)
//
//            if parts.count == 2 && parts[1].allSatisfy({ $0 == "0" }) {
//                return parts[0] == "0" ? "" : parts[0]
//            }
//
//            return editableText == "0" ? "" : editableText
//        }
//
//        let cleanedText = onChangeAmount(text)
//
//        guard let amount = Decimal(string: cleanedText, locale: .current), amount != .zero else {
//            return ""
//        }
//
//        let formatter = CurrencyConstant.localFormatter(showCents: true)
//
//        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? cleanedText
//    }
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
