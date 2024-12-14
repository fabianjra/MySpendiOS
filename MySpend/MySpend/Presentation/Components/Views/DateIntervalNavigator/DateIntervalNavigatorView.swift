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
    @Binding var isEditing: Bool
    
    var viewModel = DateIntervalNavigatorViewModel()
    
    var showEditor: Bool = false
    var trailingButtonDisabled: Bool = true
    
    var actionLeading: (() -> Void)? = nil
    var actionTrailing: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            timeInterval
                .disabled(isEditing)
                .animation(.default,value: isEditing)
            
            if showEditor {
                ZStack {
                    HStack {
                        Button {
                            isEditing.toggle()
                            if let action = actionLeading { action() }
                        } label: {
                            TextPlain(isEditing ? "Done" : "Edit")
                        }
                        
                        Spacer()
                    }
                    
                    navigator
                        .buttonStyle(ButtonScaleStyle())
                        .modifier(Show(isVisible: !isEditing))
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if let action = actionTrailing { action() }
                        } label: {
                            TextPlain("Delete", color: trailingButtonDisabled ? Color.disabledForeground : Color.alert)
                        }
                        .disabled(trailingButtonDisabled)
                        .modifier(Show(isVisible: isEditing))
                    }
                }
                .foregroundColor(Color.buttonForeground)
            } else {
                navigator
                    .buttonStyle(ButtonScaleStyle())
                    .foregroundColor(Color.buttonForeground)
            }
        }
    }
    
    var timeInterval: some View {
        Picker("Time interval", selection: $dateTimeInterval) {
            ForEach(DateTimeInterval.allCases) { type in
                Text(type.rawValue)
            }
        }
        .pickerStyle(.segmented)
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
                    .padding(.leading, ConstantViews.bigSpacing)
                    .contentShape(Rectangle())
//                        .clipShape(.rect(
//                            topLeadingRadius: .infinity,
//                            bottomLeadingRadius: .infinity)
//                        )
            }
            
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
            } label: {
                let header = viewModel.getHeader(selectedDate, by: dateTimeInterval)
                
                TextPlain(header)
                    .frame(width: FrameSize.width.buttonSelectValueIntervalCenter,
                           height: FrameSize.height.buttonSelectValueInterval)
                    .contentShape(Rectangle())
            }
            
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .next, byAdding: dateTimeInterval)
            } label: {
                Image.chevronRight
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontWeight(.thin)
                    .frame(width: FrameSize.width.buttonSelectValueInterval,
                           height: FrameSize.height.buttonSelectValueInterval)
                    .padding(.trailing, ConstantViews.bigSpacing)
                    .contentShape(Rectangle())
            }
        }
        .padding(.vertical, ConstantViews.mediumSpacing)
    }
}

#Preview {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    @Previewable @State var isEditing = false
    @Previewable @State var trailingButtonDisabled = true
    
    VStack {
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: $isEditing,
                                  showEditor: true,
                                  trailingButtonDisabled: trailingButtonDisabled)
            .background(Color.backgroundBottom.opacity(0.8))
    }
}
