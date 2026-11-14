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
                
                HStack {
                    Spacer()
                    
                    Button {
                        selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
                    } label: {
                        Text(.dateToday)
                            .font(.callout)
                            .foregroundStyle(Color.primary)
                    }
                    .opacity(!selectedDate.isSameDate(.now) ? 1 : .zero)
                    .allowsHitTesting(!selectedDate.isSameDate(.now)) // Accesibility
                    .accessibilityHidden(selectedDate.isSameDate(.now)) // Accesibility
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
            
            Text(viewModel.getHeader(selectedDate, by: dateTimeInterval))
                .font(.callout)
                .frame(width: FrameSize.width.buttonSelectValueIntervalCenter)
                .lineLimit(1)
            //.contentShape(Rectangle()) // Para seleccionar todo el componente
            
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .next, byAdding: dateTimeInterval)
            } label: {
                Image.chevronRight
                    .font(.title2.weight(.thin))
            }
        }
        .padding(.vertical, ConstantViews.mediumSpacing)
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
    .background(Color.backgroundGradient)
    .environment(\.locale, .init(identifier: Previews.localeES))
}
