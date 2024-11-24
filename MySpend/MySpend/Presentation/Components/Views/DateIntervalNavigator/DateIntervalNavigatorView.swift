//
//  DateIntervalNavigatorView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/24.
//

import SwiftUI

struct DateIntervalNavigatorView: View {
    
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    
    @StateObject var viewModel = DateIntervalNavigatorViewModel()
    
    var body: some View {
        VStack {
            timeInterval

            navigator
        }
    }
    
    var timeInterval: some View {
        Picker("Time interval", selection: $dateTimeInterval) {
            ForEach(DateTimeInterval.allCases) { type in
                Text(type.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    var navigator: some View {
        HStack {
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .previous, byAdding: dateTimeInterval)
            } label: {
                Image.chevronLeft
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontWeight(.thin)
                    .frame(width: FrameSize.width.buttonSelectValueInterval,
                           height: FrameSize.height.buttonSelectValueInterval)
                    .foregroundColor(Color.buttonForeground)
                    .padding(.vertical)
                    .padding(.leading)
                    .contentShape(Rectangle())
//                        .clipShape(.rect(
//                            topLeadingRadius: .infinity,
//                            bottomLeadingRadius: .infinity)
//                        )
            }
            .buttonStyle(ButtonScaleStyle())

            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
            } label: {
                let header = viewModel.getHeader(selectedDate, by: dateTimeInterval)
                
                TextPlain(message: header)
                    .frame(width: FrameSize.width.buttonSelectValueIntervalCenter,
                           height: FrameSize.height.buttonSelectValueInterval)
                    .padding(.vertical)
                    .contentShape(Rectangle())
            }
            .buttonStyle(ButtonScaleStyle())
            
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .next, byAdding: dateTimeInterval)
            } label: {
                Image.chevronRight
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontWeight(.thin)
                    .frame(width: FrameSize.width.buttonSelectValueInterval,
                           height: FrameSize.height.buttonSelectValueInterval)
                    .foregroundColor(Color.buttonForeground)
                    .padding(.vertical)
                    .padding(.trailing)
                    .contentShape(Rectangle())
            }
            .buttonStyle(ButtonScaleStyle())
        }
    }
}

#Preview {
    
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    ZStack {
        Color.backgroundBottom
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
    }
    
}