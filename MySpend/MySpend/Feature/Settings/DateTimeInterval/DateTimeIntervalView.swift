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
                            viewModel.selectedDateInterval = item
                        } label: {
                            HStack {
                                Text(item.localized)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(Color.primary)
                                
                                
                                Spacer()
                                
                                if item == viewModel.selectedDateInterval {
                                    Image.checkmark
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
                
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(.datetimeIntervalTitle)
        .navigationSubtitle(.datetimeIntervalSubtitle)
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
