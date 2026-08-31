//
//  DatePickerModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct DatePickerModalView: View {
    
    @State private var datePickerID = UUID()
    
    @Binding var selectedDate: Date
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .id(datePickerID)
                    .datePickerStyle(.graphical)
                //.frame(width: FrameSize.width.calendar, height: FrameSize.width.calendar)
            }
            .scrollDisabled(true)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(.datetimeToday) {
                        selectedDate = .now
                        datePickerID = UUID()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        showModal = false
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.medium])
    }
}

#Preview(Previews.localeES_CR) {
    @Previewable @State var selectedDate = Date()
    @Previewable @State var showModal = true
    @Previewable @State var dateString = ""
    
    ZStack(alignment: .top) {
        VStack {
            Text("Selected date: \(selectedDate.toStringShortLocale)")
            
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
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
