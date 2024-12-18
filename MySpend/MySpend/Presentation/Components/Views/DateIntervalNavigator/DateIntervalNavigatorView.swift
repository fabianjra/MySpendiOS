//
//  DateIntervalNavigatorView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/24.
//

import SwiftUI

struct DateIntervalNavigatorView<Content: View>: View {
    
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    @Binding var isEditing: Bool
    
    var viewModel = DateIntervalNavigatorViewModel()
    
    var showEditor: Bool = false
    var trailingButtonDisabled: Bool = true
    var counterSelected: Int = .zero
    
    var actionLeadingEdit: (() -> Void)? = nil
    var actionTrailingEdit: (() -> Void)? = nil
    
    @ViewBuilder var contentLeadingSort: () -> Content

    var body: some View {
        VStack {
            if showEditor {
                ZStack {
                    HStack {
                        Button {
                            isEditing.toggle()
                            if let action = actionLeadingEdit { action() }
                        } label: {
                            TextPlain(isEditing ? "Done" : "Edit")
                        }
                        
                        Spacer()
                    }
                    
                    TextPlain("\(counterSelected) Selected")
                        .modifier(Show(isVisible: isEditing))
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if let action = actionTrailingEdit { action() }
                        } label: {
                            TextPlain("Delete", color: trailingButtonDisabled ? Color.disabledForeground : Color.alert)
                        }
                        .disabled(trailingButtonDisabled)
                        .modifier(Show(isVisible: isEditing))
                    }
                }
            }
            
            timeInterval
                .disabled(isEditing)
                .animation(.default,value: isEditing)
            
            ZStack {
                HStack {
                    if showEditor {
                        Menu("Sort", content: contentLeadingSort)
                            .menuOrder(.fixed)
                            .foregroundStyle(isEditing ? Color.disabledForeground : Color.buttonForeground)
                    }
                    
                    Spacer()
                }
                
                navigator
                
                HStack {
                    Spacer()
                    
                    Button {
                        selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
                    } label: {
                        TextPlain("Today", color: isEditing ? Color.disabledForeground : Color.textPrimaryForeground)
                    }
                }
            }
            .disabled(isEditing)
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
            }
            
            
            Button {
                selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
            } label: {
                let header = viewModel.getHeader(selectedDate, by: dateTimeInterval)
                
                TextPlain(header, color: isEditing ? Color.disabledForeground : Color.buttonForeground)
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
        .buttonStyle(ButtonScaleStyle())
        .foregroundColor(isEditing ? Color.disabledForeground : Color.textPrimaryForeground)
    }
}

#Preview("With editor and without") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    @Previewable @State var isEditing = false
    @Previewable @State var trailingButtonDisabled = true
    
    VStack {
        Spacer()
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: $isEditing,
                                  showEditor: true,
                                  trailingButtonDisabled: trailingButtonDisabled) {}
        .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: .constant(false)) {}
        .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
    }
}
