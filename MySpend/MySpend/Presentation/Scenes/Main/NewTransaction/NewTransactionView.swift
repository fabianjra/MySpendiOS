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
        ScrollViewReader { scrollViewProxy in
            FormContainer {
                
                HeaderNavigator(title: "New transaction",
                                titleWeight: .regular,
                                titleSize: .bigXL,
                                subTitle: "Enter the new transation details",
                                onlyTitle: true)
                .padding(.vertical)
                
                
                // MARK: SEGMENT
                
                VStack {
                    PickerSegmented(selection: $newTransactionVM.newTransaction.transactionType,
                                    segments: TransactionTypeEnum.allCases)
                    .padding(.bottom)
                }
                
                // MARK: DATE
                
                VStack {
                    TextFieldReadOnly(text: $newTransactionVM.newTransaction.dateString,
                                      iconLeading: Image.calendar,
                                      colorDisabled: false)
                    .onTapGesture {
                        newTransactionVM.showDatePicker = true
                    }
                    .sheet(isPresented: $newTransactionVM.showDatePicker) {
                        NavigationView {
                            
                            DatePicker("",
                                       selection: $newTransactionVM.newTransaction.selectedDate,
                                       displayedComponents: .date)
                            .padding(.horizontal)
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
                                    .padding()
                                    .padding(.top)
                                }
                                
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        newTransactionVM.showDatePicker = false
                                    }
                                    .padding()
                                    .padding(.top)
                                }
                            }
                        }
                        .presentationCornerRadius(ConstantRadius.cornersModal)
                        .presentationDetents([.height(ConstantFrames.calendarHeight)])
                        
                    }
                    .onAppear {
                        newTransactionVM.newTransaction.dateString = Utils.dateToStringShort(date: newTransactionVM.newTransaction.selectedDate)
                    }
                }
                
                
                // MARK: TEXTFIELDS
                
                VStack {
                    TextField("", text: $newTransactionVM.newTransaction.amount, prompt:
                                Text("Amount").foregroundColor(.textFieldPlaceholder))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(TextFieldIconStyle($newTransactionVM.newTransaction.amount,
                                                       iconLeading: Image.dolarSquareFill,
                                                       textLimit: 12,
                                                       errorMessage: $newTransactionVM.errorMessage))
                    .focused($focusedField, equals: .amount)
                    
                    
                    //TODO: Change to sheet list (loading and showing all categories).
                    TextField("", text: $newTransactionVM.newTransaction.categoryId, prompt:
                                Text("Category").foregroundColor(.textFieldPlaceholder))
                    .textFieldStyle(TextFieldIconStyle($newTransactionVM.newTransaction.categoryId,
                                                       iconLeading: Image.stackFill,
                                                       errorMessage: $newTransactionVM.errorMessage))
                    .focused($focusedField, equals: .category)
                    .onSubmit { process() }
                    
                    
                    TextField("", text: $newTransactionVM.newTransaction.notes, prompt:
                                Text("Notes").foregroundColor(.textFieldPlaceholder))
                    .textFieldStyle(TextFieldIconStyle($newTransactionVM.newTransaction.notes,
                                                       errorMessage: $newTransactionVM.errorMessage))
                    .focused($focusedField, equals: .notes)
                    .padding(.bottom)
                    .id("notes")
                    .onSubmit { process() }
                }
                .modifier(AddKeyboardToolbar(focusedField: $focusedField)) //TODO: No se esta mostrando
                
                
                // MARK: BUTTONS
                
                VStack {
                    Button("Accept") {
                        process()
                    }
                    .buttonStyle(ButtonPrimaryStyle(isLoading: $newTransactionVM.isLoading))
                    .padding(.vertical)
                    .padding(.bottom)
                    
                    
                    TextError(message: newTransactionVM.errorMessage)
                }
                
                Spacer()
            }
            .onChange(of: focusedField) { _, newFocusedField in
                if focusedField == .notes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation {
                            scrollViewProxy.scrollTo("notes", anchor: .bottom)
                        }
                        
                    }
                }
            }
        }
    }
    
    private func process() {
        Task {
            let result = await newTransactionVM.addNewTransaction()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                newTransactionVM.errorMessage = result.message
            }
        }
    }
}

#Preview {
    NewTransactionView()
}
