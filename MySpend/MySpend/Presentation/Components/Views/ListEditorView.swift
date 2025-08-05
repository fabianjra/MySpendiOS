//
//  ListEditorView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/12/24.
//

import SwiftUI

struct ListEditorView: View {
    
    @Binding var isEditing: Bool
    
    var counterSelected: Int = .zero
    
    var actionLeadingEdit: (() -> Void)? = nil
    var actionTrailingEdit: (() -> Void)? = nil
    
    // Para filtrar las Accounts:
    var onlyAccountFilter: Bool = false
    var showAccountFilter: Bool = false
    var actionTrailingFilterAccounts: (() -> Void)? = nil
    
    var body: some View {
        RowLCTCointainer {
            if onlyAccountFilter == false {
                Button {
                    isEditing.toggle()
                    if let action = actionLeadingEdit { action() }
                } label: {
                    TextPlain(isEditing ? "Done" : "Edit")
                }
            }
            
        } centerContent: {
            if isEditing {
                TextPlain("\(counterSelected) Selected")
            }
            
        } trailingContent: {
            if isEditing {
                Button {
                    if let action = actionTrailingEdit { action() }
                } label: {
                    TextPlain("Delete", color: counterSelected <= 0 ? Color.disabledForeground : Color.alert)
                }
                .disabled(counterSelected <= 0)
            } else {
                if showAccountFilter {
                    Button {
                        if let action = actionTrailingFilterAccounts { action() }
                    } label: {
                        TextPlain("Accounts")
                    }
                }
            }
        }
        .animation(.default, value: isEditing)
    }
}

#Preview("With accounts filter: \(Previews.localeES)") {
    @Previewable @State var isEditing: Bool = false
    @Previewable @State var counter: Int = .zero
    
    ListEditorView(isEditing: $isEditing,
                   counterSelected: counter,
                   actionLeadingEdit: {},
                   actionTrailingEdit: {},
                   showAccountFilter: true,
                   actionTrailingFilterAccounts: {})
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeES))
    
    VStack {
        Button("Add to counter") {
            counter += 1;
        }
        
        Button("Remove from counter") {
            counter -= 1;
        }
    }
    .opacity(isEditing ? 1 : 0)
}

#Preview("No account filter: \(Previews.localeEN)") {
    @Previewable @State var isEditing: Bool = false
    @Previewable @State var counter: Int = .zero
    
    ListEditorView(isEditing: $isEditing,
                   counterSelected: counter,
                   actionLeadingEdit: {},
                   actionTrailingEdit: {})
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeEN))
    
    VStack {
        Button("Add to counter") {
            counter += 1;
        }
        
        Button("Remove from counter") {
            counter -= 1;
        }
    }
    .opacity(isEditing ? 1 : 0)
}

