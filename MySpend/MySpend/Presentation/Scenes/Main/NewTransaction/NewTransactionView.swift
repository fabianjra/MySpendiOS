//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = NewTransactionViewModel()
    @FocusState private var focusedField: TransactionModel.Field?
    
    let notesId = "notes"
    
    var body: some View {
        NavigationStack { // Needed to show toolBar Keyboard.
            ScrollViewReader { scrollViewProxy in
                FormContainer {
                    
                    HeaderNavigator(title: "New transaction",
                                    titleWeight: .regular,
                                    titleSize: .bigXL,
                                    subTitle: "Enter transation details",
                                    showLeadingAction: false,
                                    showTrailingAction: true) { dismiss() }
                    .padding(.vertical)
                    
                    
                    // MARK: SEGMENT
                    VStack {
                        PickerSegmented(selection: $viewModel.model.transactionType,
                                        segments: TransactionType.allCases)
                        .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    VStack {
                        TextFieldReadOnly(text: $viewModel.model.date,
                                          iconLeading: Image.calendar,
                                          colorDisabled: false)
                        .onTapGesture {
                            viewModel.showDatePicker = true
                        }
                    }
                    
                    
                    // MARK: TEXTFIELDS
                    VStack {
                        TextFieldAmount(text: $viewModel.amountString,
                                        errorMessage: $viewModel.errorMessage)
                        .focused($focusedField, equals: .amount)
                        .onSubmit { process() }
                        
                        //TODO: Change to sheet list (loading and showing all categories).
                        TextField("", 
                                  text: $viewModel.model.category,
                                  prompt: Text("Category").foregroundColor(.textFieldPlaceholder))
                        .textFieldStyle(TextFieldIconStyle($viewModel.model.category,
                                                           iconLeading: Image.stackFill,
                                                           errorMessage: $viewModel.errorMessage))
                        .focused($focusedField, equals: .category)
                        
                        TextFieldNotes(text: $viewModel.model.notes)
                            .id(notesId)
                            .focused($focusedField, equals: .notes)
                            .padding(.bottom)
                            .onSubmit { process() }
                        
                    }
                    .modifier(AddKeyboardToolbar(focusedField: $focusedField))
                    
                    
                    // MARK: BUTTONS
                    VStack {
                        Button("Accept") {
                            process()
                        }
                        .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                        .padding(.vertical)
                        .padding(.bottom)
                        
                        
                        TextError(message: viewModel.errorMessage)
                    }
                    
                    Spacer()
                }
                .onAppear {
                    viewModel.onAppear()
                }
                .onChange(of: focusedField) { _, newFocusedField in
                    if focusedField == .notes {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation {
                                scrollViewProxy.scrollTo(notesId, anchor: .bottom)
                            }
                            
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    NavigationStack {
                        DatePicker("",
                                   selection: $viewModel.selectedDate,
                                   displayedComponents: .date)
                        .padding(.horizontal)
                        .datePickerStyle(.graphical)
                        .frame(height: ConstantFrames.calendarHeight)
                        .padding()
                        .onChange(of: viewModel.selectedDate, { oldValue, newValue in
                            viewModel.model.date = Utils.dateToStringShort(date: newValue)
                            //let day = selectedDate.formatted(.dateTime.day())
                        })
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Today") {
                                    viewModel.selectedDate = .now
                                }
                                .padding()
                                .padding(.top)
                            }
                            
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    viewModel.showDatePicker = false
                                }
                                .padding()
                                .padding(.top)
                            }
                        }
                    }
                    .presentationCornerRadius(ConstantRadius.cornersModal)
                    .presentationDetents([.height(ConstantFrames.calendarHeight)])
                }
            }
        }
    }
    
    private func process() {
        focusedField = .none
        Task {
            let result = await viewModel.addNewTransaction()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview {
    NewTransactionView()
}
