//
//  DatePickerModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct DatePickerModalView: View {

    @Binding var model: TransactionModel
    @Binding var showModal: Bool
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .padding(.horizontal)
            .datePickerStyle(.graphical)
            .frame(height: ConstantFrames.calendarHeight)
            .padding()
            .onChange(of: selectedDate, { oldValue, newValue in
                model.date = Utils.dateToStringShort(date: newValue)
                //let day = selectedDate.formatted(.dateTime.day())
            })
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Today") {
                        selectedDate = .now
                    }
                    .padding()
                    .padding(.top)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showModal = false
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

#Preview {
    @Previewable @State var model = TransactionModel()
    @Previewable @State var showModal = true
    @Previewable @State var selectedDate = Date.now
    
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain(message: "Selected date: \(selectedDate)")
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        DatePickerModalView(model: $model, showModal: $showModal, selectedDate: $selectedDate)
    }
    .onAppear {
        showModal = true
    }
}
