//
//  TransactionForm.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/11/26.
//

import SwiftUI

struct TransactionForm: View {
    
    @Environment(AccountManager.self) private var accountManager
    
    // PARAMETRIZADOS
    @Binding var transaction: TransactionModel
    @Binding var type: CategoryType
    @Binding var amountString: String
    
    @FocusState private var isFocused: Bool
    private var showAccountTextField: Bool {
        accountManager.sortedAccounts.count > 1
    }
    
    //SHEETS
    @State private var showDatePicker = false
    @State private var showCategoryList = false
    @State private var showAccountList = false
    
    var body: some View {
        VStack {
            CategoryPickerView(selection: $type)
                .glassEffect(.regular)
                .padding(.horizontal)
            
            Form {
                Section {
                    
                    Button {
                        showDatePicker = true
                    } label: {
                        HStack(spacing: ConstantViews.formLabeledContentSpacing) {
                            Text(.transactionInputDate)
                                .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
                            
                            Text(transaction.dateTransaction.toStringShortLocale)
                            
                            Spacer()
                            
                            Image.calendar
                        }
                        .foregroundStyle(Color.primary)
                    }
                    
                    
                    LabeledContent(.transactionInputAmount) {
                        TextField(.transactionInputAmountPlaceholder, text: $amountString)
                            .formInputStyle($amountString)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                    }
                    .formLabeledInputStyle
                    
                    
                    Button {
                        showCategoryList = true
                    } label: {
                        HStack(spacing: ConstantViews.formLabeledContentSpacing) {
                            Text(.transactionInputCategory)
                                .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
                            
                            Text(transaction.category.name.isEmptyOrWhitespace
                                 ? .transactionInputCategoryPlaceholder
                                 : LocalizedStringResource(stringLiteral: transaction.category.name))
                            
                            .foregroundStyle(transaction.category.name.isEmptyOrWhitespace
                                             ? Color(uiColor: .placeholderText) : Color.primary)
                        }
                        .foregroundStyle(Color.primary)
                    }
                    
                    
                    if showAccountTextField {
                        Button {
                            showAccountList = true
                        } label: {
                            HStack(spacing: ConstantViews.formLabeledContentSpacing) {
                                Text(.transactionInputAccount)
                                    .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
                                
                                Text(transaction.account.name.isEmptyOrWhitespace
                                     ? .transactionInputAccountPlaceholder
                                     : LocalizedStringResource(stringLiteral: transaction.account.name))
                                
                                .foregroundStyle(transaction.account.name.isEmptyOrWhitespace
                                                 ? Color(uiColor: .placeholderText) : Color.primary)
                            }
                            .foregroundStyle(Color.primary)
                        }
                    }
                    
                    
                    LabeledContent(.transactionInputNotes) {
                        TextField(.transactionInputNotesPlaceholder, text: $transaction.notes, axis: .vertical)
                            .formInputStyle($transaction.notes, textLimit: 160)
                            .keyboardType(.alphabet)
                    }
                    .formLabeledInputStyle
                    
                    
                    Toggle(isOn: $transaction.favorite) {
                        Text(.favoriteMarkFavorite)
                    }
                    .tint(.accentColor)
                    
                } footer: {
                    VStack(alignment: .leading) {
                        if transaction.category.name.isEmptyOrWhitespace {
                            Text(.transactionInputCategoryRequired)
                                .foregroundStyle(.alert)
                        }
                        
                        if transaction.account.name.isEmptyOrWhitespace {
                            Text(.transactionInputAccountRequired)
                                .foregroundStyle(.alert)
                        }
                    }
                }
            }
            //.scrollDisabled(transaction.notes.isEmptyOrWhitespace)
            .scrollContentBackground(.hidden)
        }
        
        // MARK: EVENTS

        .onAppear {
            isFocused = true
            configureSelectedAccount()
        }
        .onChange(of: amountString) { _, newValue in
            guard isFocused else { return }

            let filteredValue = onChangeAmount(newValue)

            if filteredValue != newValue {
                amountString = filteredValue
            }
        }
        .onChange(of: isFocused) { _, newValue in
            amountString = onChangeFocusAmount(amountString, newValue)
        }
        .onChange(of: type) {
            transaction.category = CategoryModel()
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
    
    //TODO: Agregar la validacion de cuando es UPDATE: Debe seleccionar la que tiene la transaccion
    private func configureSelectedAccount() {
        let accounts = accountManager.sortedAccounts

        guard !accounts.isEmpty else { return }

        transaction.account = accounts.first { $0.id == accountManager.defaultAccount?.id } ?? accounts[0]
    }
    
    private func onChangeAmount(_ text: String) -> String {
        let decimalSeparator = CurrencyManager.localDecimalSeparator
        let groupingSeparator = CurrencyManager.localGroupingSeparator

        let cleanedText = text.replacingOccurrences(of: groupingSeparator, with: "")

        let parts = cleanedText.components(separatedBy: decimalSeparator)

        let integerPart = String(parts[0].filter(\.isASCII).filter(\.isNumber).prefix(CurrencyManager.amoutMaxLength))

        guard parts.count > 1 else {
            return integerPart
        }

        let decimalPart = String(parts.dropFirst().joined().filter(\.isASCII).filter(\.isNumber).prefix(2))

        return integerPart + decimalSeparator + decimalPart
    }
        
    private func onChangeFocusAmount(_ text: String, _ isFocused: Bool) -> String {
        let decimalSeparator = CurrencyManager.localDecimalSeparator
        let groupingSeparator = CurrencyManager.localGroupingSeparator

        if isFocused {
            let editableText = text.replacingOccurrences(of: groupingSeparator,with: "")

            let parts = editableText.components(separatedBy: decimalSeparator)

            if parts.count == 2 && parts[1].allSatisfy({ $0 == "0" }) {
                return parts[0] == "0" ? "" : parts[0]
            }

            return editableText == "0" ? "" : editableText
        }

        let cleanedText = onChangeAmount(text)

        guard let amount = Decimal(string: cleanedText, locale: .current), amount != .zero else {
            return ""
        }

        let formatter = UtilsCurrency.getLocalFormatter

        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? cleanedText
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var accountManager = AccountManager.shared
    @Previewable @State var categoryManager = CategoryManager.shared
    
    @Previewable @State var transaction = TransactionModel()
    @Previewable @State var type = CategoryType.expense
    @Previewable @State var amountString = ""
    
    TransactionForm(transaction: $transaction, type: $type, amountString: $amountString)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
    
        .environment(accountManager)
        .environment(categoryManager)
}
