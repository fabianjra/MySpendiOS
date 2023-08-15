//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct ModalNewTransaction: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var dateString: String = ""
    @State private var isDateError: Bool = false
    
    @State private var date = Date.now

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
            
            
            DatePicker("Date:", selection: $date, displayedComponents: .date)
                .padding()
                .foregroundColor(Color.textPrimaryForeground)
                .onChange(of: date) { newDate in
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let dateFormted = dateFormatter.string(from: newDate)
                    
                    
                    dateString = dateFormted
                    
                    
                    print("*******************")
                    print(dateFormted)
                }
                .labelsHidden()
            
            
            TextField("", text: $dateString, prompt: Text("Date"))
                .textFieldStyle(TextFieldIconStyle($dateString,
                                                   iconLeading: Image.calendar,
                                                   isError: $isDateError))
                .disabled(true)
            
            
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
