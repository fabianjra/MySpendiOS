//
//  DatePickerModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct DatePickerModalView: View {
    
    @ObservedObject var viewModel: NewTransactionViewModel
    
    var body: some View {
        NavigationStack {
            DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
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

#Preview {
    @Previewable @StateObject var viewModel = NewTransactionViewModel()
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain(message: "Selected date: \(viewModel.selectedDate)")
            
            Button("Show modal") {
                viewModel.showDatePicker = true
            }
            Spacer()
        }
    }.sheet(isPresented: $viewModel.showDatePicker) {
        DatePickerModalView(viewModel: viewModel)
    }
    .onAppear {
        viewModel.showDatePicker = true
    }
}
