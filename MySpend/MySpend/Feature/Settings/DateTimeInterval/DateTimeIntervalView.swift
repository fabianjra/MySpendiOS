//
//  DateTimeIntervalListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import SwiftUI

struct DateTimeIntervalView: View {
    
    @State private var viewModel = DateTimeIntervalViewModel()
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(DateTimeInterval.allCases) { item in
                        Button {
                            viewModel.DateTimeIntervalSelected = item
                        } label: {
                            HStack {
                                Text(item.localized)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(Color.primary)
                                
                                
                                Spacer()
                                
                                if item == viewModel.DateTimeIntervalSelected {
                                    Image.checkmark
                                        .bold()
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button(.buttonRestoreSelection) {
                        viewModel.resetDateTimeInterval()
                    }
                }
                //.listRowBackground(Color.clear)
                
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Time interval list")
        .navigationSubtitle("Select the new time interval")
        .background(Color.backgroundGradient)
    }
}

#Preview(Previews.localeES) {
    NavigationStack {
        DateTimeIntervalView()
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    NavigationStack {
        DateTimeIntervalView()
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
