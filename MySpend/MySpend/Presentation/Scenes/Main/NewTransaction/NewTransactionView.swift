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
    @FocusState private var focusedField: NewTransaction.Field?
    
    let notesId = "notes"
    
    var body: some View {
        NavigationStack { // Needed to show toolBar Keyboard.
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
                        PickerSegmented(selection: $viewModel.model.transactionType,
                                        segments: TransactionTypeEnum.allCases)
                        .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    VStack {
                        TextFieldReadOnly(text: $viewModel.model.dateString,
                                          iconLeading: Image.calendar,
                                          colorDisabled: false)
                        .onTapGesture {
                            focusedField = nil
                            viewModel.showDatePicker = true
                        }
                        .sheet(isPresented: $viewModel.showDatePicker) {
                            NavigationStack {
                                DatePicker("",
                                           selection: $viewModel.model.selectedDate,
                                           displayedComponents: .date)
                                .padding(.horizontal)
                                .datePickerStyle(.graphical)
                                .frame(height: ConstantFrames.calendarHeight)
                                .onChange(of: viewModel.model.selectedDate, { oldValue, newValue in
                                    viewModel.model.dateString = Utils.dateToStringShort(date: newValue)
                                    //let day = selectedDate.formatted(.dateTime.day())
                                })
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Today") {
                                            viewModel.model.selectedDate = .now
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
                    
                    
                    // MARK: TEXTFIELDS
                    VStack {
                        TextField("", text: $viewModel.model.amount, prompt:
                                    Text("Amount").foregroundColor(.textFieldPlaceholder))
                        .textFieldStyle(TextFieldIconStyle($viewModel.model.amount,
                                                           iconLeading: Image.dolarSquareFill,
                                                           textLimit: ConstantViews.amoutMaxLength,
                                                           errorMessage: $viewModel.errorMessage))
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)
                        
                        
                        //TODO: Change to sheet list (loading and showing all categories).
                        TextField("", text: $viewModel.model.categoryId, prompt:
                                    Text("Category").foregroundColor(.textFieldPlaceholder))
                        .textFieldStyle(TextFieldIconStyle($viewModel.model.categoryId,
                                                           iconLeading: Image.stackFill,
                                                           errorMessage: $viewModel.errorMessage))
                        .focused($focusedField, equals: .category)
                        .onSubmit { process() }
                        
                        
                        TextField("", text: $viewModel.model.notes, prompt:
                                    Text("Notes").foregroundColor(.textFieldPlaceholder))
                        .textFieldStyle(TextFieldIconStyle($viewModel.model.notes,
                                                           errorMessage: $viewModel.errorMessage))
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
            }
        }
    }
    
    private func process() {
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
