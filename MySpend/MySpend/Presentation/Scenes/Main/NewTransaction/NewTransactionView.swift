//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.dismiss) var dismiss

    @StateObject var newTransactionVM = NewTransactionViewModel()
    @FocusState private var focusedField: NewTransaction.Field?
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "New transaction",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Enter the new transation details",
                            onlyTitle: true)
            .padding(.vertical)
            

            PickerSegmented(selection: $newTransactionVM.newTransaction.transactionType,
                            segments: TransactionTypeEnum.allCases)
            .padding(.bottom)
            
            
            TextFieldReadOnly(text: $newTransactionVM.newTransaction.dateString,
                              iconLeading: Image.calendar,
                              colorDisabled: false)
                .onTapGesture {
                    newTransactionVM.newTransaction.showDatePicker = true
                }
                .sheet(isPresented: $newTransactionVM.newTransaction.showDatePicker) {
                    NavigationStack {
                        
                        DatePicker("",
                                   selection: $newTransactionVM.newTransaction.selectedDate,
                                   displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .onChange(of: newTransactionVM.newTransaction.selectedDate, { oldValue, newValue in
                                newTransactionVM.newTransaction.dateString = Utils.dateToStringShort(date: newValue)
                                //let day = selectedDate.formatted(.dateTime.day())
                            })
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Today") {
                                        newTransactionVM.newTransaction.selectedDate = .now
                                    }
                                }
                                
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        newTransactionVM.newTransaction.showDatePicker = false
                                    }
                                }
                            }
                    }
                    .presentationDetents([.medium])
                }
                .onAppear {
                    newTransactionVM.newTransaction.dateString = Utils.dateToStringShort(date: newTransactionVM.newTransaction.selectedDate)
                }
            
            
            TextField("", text: $newTransactionVM.newTransaction.amount, prompt:
                        Text("Amount").foregroundColor(.textFieldPlaceholder))
            .keyboardType(.decimalPad)
            .textFieldStyle(TextFieldIconStyle($newTransactionVM.newTransaction.amount,
                                               iconLeading: Image.dolarSquareFill,
                                               textLimit: 12,
                                               errorMessage: $newTransactionVM.newTransaction.errorMessage))
            .focused($focusedField, equals: .amount)
            .onSubmit { focusedField = .category }
            
            
            //TODO: Change to sheet list (all categories inserted).
            TextField("", text: $newTransactionVM.newTransaction.category, prompt:
                        Text("Category").foregroundColor(.textFieldPlaceholder))
            .textFieldStyle(TextFieldIconStyle($newTransactionVM.newTransaction.category,
                                               iconLeading: Image.stackFill,
                                               errorMessage: $newTransactionVM.newTransaction.errorMessage))
            .focused($focusedField, equals: .category)
            .onSubmit { focusedField = .notes }
            
            
            TextField("", text: $newTransactionVM.newTransaction.notes, prompt:
                        Text("Notes").foregroundColor(.textFieldPlaceholder))
            .textFieldStyle(TextFieldIconStyle($newTransactionVM.newTransaction.notes,
                                               errorMessage: $newTransactionVM.newTransaction.errorMessage))
            .focused($focusedField, equals: .notes)
            .padding(.bottom)
            .onSubmit {
                Task {
                    focusedField = .none
                    await newTransactionVM.addNewTransaction()
                    dismiss()
                }
            }
            
            
            Button("Accept") {
                Task {
                    focusedField = .none
                    await newTransactionVM.addNewTransaction()
                    dismiss()
                }
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $newTransactionVM.newTransaction.isLoading))
            .padding(.vertical)
            .padding(.bottom)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(ButtonPrimaryStyle(color: [Color.warning]))
            .padding(.vertical)
            .padding(.horizontal)
            
            
            TextError(message: newTransactionVM.newTransaction.errorMessage)
        }
    }
}

#Preview {
    NewTransactionView()
}
