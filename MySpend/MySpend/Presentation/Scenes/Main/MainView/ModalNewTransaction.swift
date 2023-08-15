//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

private enum TransactionType: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case expense = "expense"
    case income = "income"
}

struct ModalNewTransaction: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var transactionType: TransactionType = .expense
    
    @State private var dateString: String = ""
    
    @State private var date = Date()
    
    @State private var showingPicker = false

    @State private var amount: String = ""
    @State private var isAmountError: Bool = false
    
    @State private var category: String = ""
    @State private var isCategoryError: Bool = false
    
    @State private var notes: String = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "New transaction",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Enter the new transation details",
                            onlyTitle: true)
            .padding(.vertical)
            
            
            Picker("Transaction type", selection: $transactionType) {
                ForEach(TransactionType.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            
            
//            TextField("", text: $dateString, prompt:
//                        Text("Date").foregroundColor(.textFieldPlaceholder))
//                .textFieldStyle(TextFieldIconStyle($dateString,
//                                                   iconLeading: Image.calendar,
//                                                   isError: $isDateError))
            
            Text(dateString)
                .font(.montserrat())
                .foregroundColor(Color.textPrimaryForeground)
                .onTapGesture {
                    showingPicker = true
                }
                .sheet(isPresented: $showingPicker) {
                    
                    DatePicker(selection: $date, displayedComponents: .date) {
                        
                    }
                    .onChange(of: date, perform: { newDate in
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let dateFormated = dateFormatter.string(from: newDate)
                        dateString = dateFormated
                        
                        showingPicker = false
                    })
                    .datePickerStyle(.graphical)
                    .presentationDetents([.medium])
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingPicker = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingPicker = false
                            }
                        }
                    }
                }
                .onAppear {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let dateFormated = dateFormatter.string(from: date)
                    dateString = dateFormated
                }
            
            
            TextField("", text: $amount, prompt:
                        Text("Amount").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($amount,
                                                   iconLeading: Image.dolarSquareFill,
                                                   textLimit: 9,
                                                   isError: $isAmountError))
            
            
            TextField("", text: $category, prompt:
                        Text("Category").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($category,
                                                   iconLeading: Image.stackFill,
                                                   isError: $isCategoryError))
            
            
            TextField("", text: $notes, prompt:
                        Text("Notes").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($notes,
                                                   isError: $isAmountError))
                .padding(.bottom)
            
            
            Button("Accept") {
                
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
            .padding(.vertical)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(ButtonPrimaryStyle(color: [Color.warning]))
        }
    }
}

struct ModalNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        ModalNewTransaction()
    }
}
