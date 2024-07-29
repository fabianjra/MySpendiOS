//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

private enum Field: Hashable {
    case amount
    case category
    case notes
}

struct ModalNewTransaction: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var transactionType: TransactionTypeEnum = .expense
    
    @State private var dateString: String = ""
    
    @State private var selectedDate: Date = .now
    
    @State private var showingPicker = false
    
    @State private var amount: String = ""
    @State private var isAmountError: Bool = false
    
    @State private var category: String = ""
    @State private var isCategoryError: Bool = false
    
    @State private var notes: String = ""
    
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "New transaction",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Enter the new transation details",
                            onlyTitle: true)
            .padding(.vertical)
            
            
            Picker("Transaction type", selection: $transactionType) {
                ForEach(TransactionTypeEnum.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .colorMultiply(transactionType == .expense ? .warning : .primaryLeading)
            .padding(.bottom)
            
            
            TextFieldReadOnly(text: $dateString, iconLeading: Image.calendar, colorDisabled: false)
                .onTapGesture {
                    showingPicker = true
                }
                .sheet(isPresented: $showingPicker) {
                    NavigationStack {
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .onChange(of: selectedDate, { oldValue, newValue in
                                dateString = Utils.dateToStringShort(date: selectedDate)
                                //let day = selectedDate.formatted(.dateTime.day())
                            })
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Today") {
                                        selectedDate = .now
                                    }
                                }
                                
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        showingPicker = false
                                    }
                                }
                            }
                    }
                    .presentationDetents([.medium])
                }
                .onAppear {
                    dateString = Utils.dateToStringShort(date: selectedDate)
                }
            
            
            TextField("", text: $amount, prompt:
                        Text("Amount").foregroundColor(.textFieldPlaceholder))
            .keyboardType(.decimalPad)
            .textFieldStyle(TextFieldIconStyle($amount,
                                               iconLeading: Image.dolarSquareFill,
                                               textLimit: 12,
                                               isError: $isAmountError))
            .focused($focusedField, equals: .amount)
            .onSubmit { focusedField = .category }
            .onChange(of: amount) { errorMessage = "" }
            
            
            //TODO: Change to sheet list (all categories inserted).
            TextField("", text: $category, prompt:
                        Text("Category").foregroundColor(.textFieldPlaceholder))
            .textFieldStyle(TextFieldIconStyle($category,
                                               iconLeading: Image.stackFill,
                                               isError: $isCategoryError))
            .focused($focusedField, equals: .category)
            .onSubmit { focusedField = .notes }
            .onChange(of: category) { errorMessage = "" }
            
            
            TextField("", text: $notes, prompt:
                        Text("Notes").foregroundColor(.textFieldPlaceholder))
            .textFieldStyle(TextFieldIconStyle($notes,
                                               isError: $isAmountError))
            .focused($focusedField, equals: .notes)
            .onChange(of: notes) { errorMessage = "" }
            .padding(.bottom)
            .onSubmit {
                Task {
                    await addNewTransaction()
                }
            }
            
            
            Button("Accept") {
                Task {
                    await addNewTransaction()
                }
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
            .padding(.vertical)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(ButtonPrimaryStyle(color: [Color.warning]))
            
            
            TextError(message: errorMessage)
        }
    }
    
    private func addNewTransaction() async {
        errorMessage = ""
        focusedField = .none
        
        isAmountError = amount.isEmptyOrWhitespace()
        isCategoryError = category.isEmptyOrWhitespace()
        
        if isAmountError || isCategoryError {
            errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        isLoading = true
        
        do {
            defer {
                isLoading = false
            }
            
            let categoryModel = CategoryModel(description: category)
            
            let transactionModel = TransactionModel(amount: Double(amount),
                                                   date: Utils.StringShortDateToDate(dateShort: dateString),
                                                   category: categoryModel,
                                                   detail: notes,
                                                   type: transactionType)
            try await SessionStore.setNewTransaction(transactionModel: transactionModel)
            
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ModalNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        ModalNewTransaction()
    }
}
