//
//  DateTimeNavigatorView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/24.
//

import SwiftUI

struct DateTimeNavigatorView: View {
    
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    
    private var viewModel = DateTimeNavigatorViewModel()
    
    var body: some View {
        VStack {
            Picker(.settingsOptionDateInterval, selection: $dateTimeInterval) {
                ForEach(DateTimeInterval.allCases) { item in
                    Text(item.localized)
                }
            }
            .pickerStyle(.segmented)
            .glassEffect(.regular)
            
            
            ZStack {
                HStack {
                    Spacer()
                }
                
                navigator
                    .padding(.top, ConstantViews.mediumSpacing)
                
                HStack {
                    Spacer()
                }
            }
        }
        .onChange(of: dateTimeInterval) { _, newInterval in
            selectedDate = viewModel.normalizeDateTime(selectedDate, for: newInterval)
        }
    }
    
    var navigator: some View {
        HStack {
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .previous, byAdding: dateTimeInterval)
            } label: {
                Image.chevronLeft
                    .font(.title2.weight(.thin))
            }
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
            } label: {
                VStack(spacing: .zero) {
                    Text(viewModel.getHeader(selectedDate, by: dateTimeInterval))
                        .lineLimit(1)
                        //.font(.callout)
                        .frame(width: 180)
                        .overlay(alignment: .bottom) {
                            if !selectedDate.isSameDate(.now) {
                                Text(.dateIntervalGoToToday)
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                                    .fixedSize()
                                    .offset(y: 14)
                            }
                        }
                }
            }
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .next, byAdding: dateTimeInterval)
            } label: {
                Image.chevronRight
                    .font(.title2.weight(.thin))
            }
        }
        .foregroundColor(Color.primary)
    }
}

#Preview(Previews.localeES) {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        Spacer()
        DateTimeNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate)
        Spacer()
    }
    .background(.blue.opacity(0.3))
    .environment(\.locale, .init(identifier: Previews.localeES))
}
