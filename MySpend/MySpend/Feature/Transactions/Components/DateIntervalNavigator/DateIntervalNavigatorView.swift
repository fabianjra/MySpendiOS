//
//  DateIntervalNavigatorView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/24.
//

import SwiftUI

struct DateIntervalNavigatorView: View {
    
    @Binding var dateInterval: DateInterval
    @Binding var selectedDate: Date
    
    private var viewModel = DateIntervalNavigatorViewModel()
    
    var body: some View {
        VStack {
            
            Picker(.settingsGeneralOptionDateInterval, selection: $dateInterval) {
                ForEach(DateInterval.allCases) { item in
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
                        selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateInterval)
                    } label: {
                        Text(.dateToday)
                            .font(.callout)
                            .foregroundStyle(Color.primary)
                    }
                    .opacity(!selectedDate.isSameDate(.now) ? 1 : .zero)
                }
            }
        }
    }
    
    var navigator: some View {
        HStack {
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .previous, byAdding: dateInterval)
            } label: {
                Image.chevronLeft
                    .font(.title2)
                    .fontWeight(.thin)
            }
            
            Text(viewModel.getHeader(selectedDate, by: dateInterval))
                .font(.callout)
                .frame(width: FrameSize.width.buttonSelectValueIntervalCenter)
                .lineLimit(1)
            //.contentShape(Rectangle()) // Para seleccionar todo el componente
            
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .next, byAdding: dateInterval)
            } label: {
                Image.chevronRight
                    .font(.title2)
                    .fontWeight(.thin)
            }
        }
        .padding(.vertical, ConstantViews.mediumSpacing)
        .foregroundColor(Color.primary)
    }
}

#Preview(Previews.localeES) {
    @Previewable @State var dateInterval = DateInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        Spacer()
        DateIntervalNavigatorView(dateInterval: $dateInterval,
                                  selectedDate: $selectedDate)
        Spacer()
    }
    .background(Color.backgroundGradient)
    .environment(\.locale, .init(identifier: Previews.localeES))
}
