//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct ModalNewTransaction: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var date: String = ""
    @State private var isDateError: Bool = false
    
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
            
            TextField("", text: $date, prompt: Text("Date"))
                .textFieldStyle(TextFieldIconStyle($date,
                                                   iconLeading: Image.calendar,
                                                   textLimit: 9,
                                                   isError: $isDateError))
            
            TextField("", text: $amount, prompt: Text("Amount"))
                .textFieldStyle(TextFieldIconStyle($amount,
                                                   iconLeading: Image.dolarSquareFill,
                                                   textLimit: 9,
                                                   isError: $isAmountError))
            
            
            TextField("", text: $category, prompt: Text("Category"))
                .textFieldStyle(TextFieldIconStyle($category,
                                                   iconLeading: Image.stackFill,
                                                   isError: $isCategoryError))
            
            
            TextField("", text: $notes, prompt: Text("Notes"))
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
