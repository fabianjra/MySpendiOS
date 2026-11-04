//
//  TransactionForm.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/11/26.
//

import SwiftUI

struct TransactionForm: View {
    
    // PARAMETRIZADOS
    @Binding var transaction: TransactionModel
    @Binding var type: CategoryType
    
    @State private var amountString = ""
    
    @FocusState private var isFocused: Bool
    
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
                        }
                        .foregroundStyle(Color.primary)
                    }
                    
                    
                    LabeledContent(.transactionInputAmount) {
                        TextField(.transactionInputAmountPlaceholder, text: $amountString)
                            .formInputStyle($amountString)
                            .autocorrectionDisabled()
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
                                             ? Color.secondary : Color.primary)
                        }
                        .foregroundStyle(Color.primary)
                    }
                    
                    
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
                                             ? Color.secondary : Color.primary)
                        }
                        .foregroundStyle(Color.primary)
                    }
                    
                    
                    LabeledContent(.transactionInputNotes) {
                        TextField(.transactionInputNotesPlaceholder, text: $transaction.notes, axis: .vertical)
                            .formInputStyle($transaction.notes)
                            .keyboardType(.alphabet)
                    }
                    .formLabeledInputStyle
                    
                    
                    Toggle(isOn: $transaction.favorite) {
                        Text(.favoriteMarkFavorite)
                    }
                    .tint(.accentColor)
                    
                } footer: {}
            }
            .scrollDisabled(true)
            //.scrollContentBackground(.hidden)
        }
        
        // MARK: EVENTS
        
        .onAppear {
            isFocused = true
        }
        .onAppear {
            amountString = transaction.amount.convertAmountDecimalToString
        }
        .onChange(of: transaction.amount) {
            amountString = transaction.amount.convertAmountDecimalToString
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
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var accountManager = AccountManager.shared
    @Previewable @State var categoryManager = CategoryManager.shared
    
    @Previewable @State var transaction = TransactionModel()
    @Previewable @State var type = CategoryType.expense
    
    TransactionForm(transaction: $transaction, type: $type)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
    
        .environment(accountManager)
        .environment(categoryManager)
}
