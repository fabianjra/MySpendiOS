//
//  DatePickerModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct DatePickerModalView: View {
    
    @Binding var model: TransactionModel
    @Binding var dateString: String
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationStack {
            DatePicker("", selection: $model.dateTransaction, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .frame(width: FrameSize.width.calendar, height: FrameSize.width.calendar)
                .scaleEffect(ConstantViews.calendarScale)
                .onChange(of: model.dateTransaction) { _, newValue in
                    dateString = newValue.toStringShortLocale()
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Today") {
                            model.dateTransaction = .now
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
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(ConstantRadius.cornersModal)
        .presentationDetents([.height(FrameSize.height.calendar)])
    }
}

#Preview {
    @Previewable @State var model = TransactionModel()
    @Previewable @State var showModal = true
    @Previewable @State var dateString = ""
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            TextPlain(message: "Selected date: \(dateString)")
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        DatePickerModalView(model: $model, dateString: $dateString, showModal: $showModal)
    }
    .onAppear {
        dateString = model.dateTransaction.toStringShortLocale()
        showModal = true
    }
}
