//
//  DatePickerModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct DatePickerModalView: View {
    
    @Binding var selectedDate: Date
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .frame(width: FrameSize.width.calendar, height: FrameSize.width.calendar)
                .scaleEffect(ConstantViews.calendarScale)
                .padding(.bottom, 70)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Today") {
                            selectedDate = .now
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showModal = false
                        }
                    }
                }
        }
        .presentationDragIndicator(.visible)
        //.presentationCornerRadius(ConstantRadius.cornersModal)
        //.presentationDetents([.height(FrameSize.height.calendar)])
        .presentationDetents([.medium])
    }
}

#Preview {
    @Previewable @State var selectedDate = Date()
    @Previewable @State var showModal = true
    @Previewable @State var dateString = ""
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            TextPlain("Selected date: \(selectedDate.toStringShortLocale)")
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        DatePickerModalView(selectedDate: $selectedDate, showModal: $showModal)
    }
    .onAppear {
        dateString = selectedDate.toStringShortLocale
        showModal = true
    }
}
