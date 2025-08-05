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
    var counterSelected: Int = .zero
    
    var actionLeadingEdit: (() -> Void)? = nil
    var actionTrailingEdit: (() -> Void)? = nil
    
    // Para filtrar las Accounts:
    var onlyAccountFilter: Bool = false
    var showAccountFilter: Bool = false
    var actionTrailingFilterAccounts: (() -> Void)? = nil
    
    @ViewBuilder var contentLeadingSort: () -> Content
    
    var body: some View {
        VStack {
            if showEditor {
                ListEditorView(isEditing: $isEditing,
                               counterSelected: counterSelected,
                               actionLeadingEdit: {
                    if let action = actionLeadingEdit { action() }
                }, actionTrailingEdit: {
                    if let action = actionTrailingEdit { action() }
                },
                               showAccountFilter: showAccountFilter,
                               actionTrailingFilterAccounts: {
                    if let action = actionTrailingFilterAccounts { action() }
                    
                })
            } else {
                if showAccountFilter {
                    ListEditorView(isEditing: .constant(false),
                                   counterSelected: .zero,
                                   actionLeadingEdit: {}, actionTrailingEdit: {},
                                   onlyAccountFilter: onlyAccountFilter,
                                   showAccountFilter: showAccountFilter,
                                   actionTrailingFilterAccounts: {
                        if let action = actionTrailingFilterAccounts { action() }
                    })
                }
            }
            
            PickerView(selection: $dateTimeInterval)
                .disabled(isEditing)
                .animation(.default,value: isEditing)
            
            
            RowLCTCointainer(disabled: isEditing) {
                if showEditor {
                    MenuContainer(disabled: isEditing) {
                        contentLeadingSort()
                    }
                }
            } centerContent: {
                navigator
                
            } trailingContent: {
                Button {
                    selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
                } label: {
                    TextPlain("Today", color: isEditing ? Color.disabledForeground : Color.textPrimaryForeground)
                }
                .modifier(ShowReservesSpace(!selectedDate.isSameDate(.now))) //Uses modifier because need to keep space.
            }
        }
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
                //Pressed many times by mistake. There is now a button to the right called "today".
                //selectedDate = viewModel.navigateDateTime(selectedDate, to: .today, byAdding: dateTimeInterval)
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

#Preview("With account filter \(Previews.localeES)") {
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
                                  showAccountFilter: true) {}
            .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: .constant(false)) {}
            .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview("Only account filter \(Previews.localeES)") {
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
                                  showAccountFilter: true) {}
            .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: .constant(false),
                                  showAccountFilter: true,
                                  actionTrailingFilterAccounts: {}){}
            .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}


#Preview("No account filter \(Previews.localeEN)") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    @Previewable @State var isEditing = false
    @Previewable @State var trailingButtonDisabled = true
    
    VStack {
        Spacer()
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: $isEditing,
                                  showEditor: true) {}
            .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: .constant(false)) {}
            .background(Color.backgroundBottom.opacity(0.8))
        
        Spacer()
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
