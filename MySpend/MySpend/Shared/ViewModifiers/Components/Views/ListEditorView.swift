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
    
    var body: some View {
        RowLCTCointainer {
            Button {
                isEditing.toggle()
                if let action = actionLeadingEdit { action() }
            } label: {
                TextPlain(isEditing ? "Done" : "Edit")
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
            }
        }
        .animation(.default, value: isEditing)
    }
}

#Preview {
    @Previewable @State var isEditing: Bool = false
    @Previewable @State var counter: Int = .zero
    
    ListEditorView(isEditing: $isEditing,
                   counterSelected: counter,
                   actionLeadingEdit: {},
                   actionTrailingEdit: {})
    .background(Color.backgroundBottom)
    
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
