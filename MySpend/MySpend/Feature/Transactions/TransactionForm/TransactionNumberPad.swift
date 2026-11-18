//
//  TransactionNumberPad.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/11/26.
//

import SwiftUI

struct TransactionNumberPad: View {
    
    var showDelete = false
    
    let onDigit: (String) -> Void
    let onDecimal: () -> Void
    let onErase: () -> Void
    let onClear: () -> Void
    let onConfirm: () -> Void
    var onDelete: (() -> Void)? = nil

    private let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"]
    ]
    
    private let numberButtonHeight: CGFloat = 50
    private let actionButtonHeight: CGFloat = 35

    var body: some View {
        VStack {

            ForEach(rows, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { digit in
                        numberButton(digit)
                    }
                }
            }

            HStack {
                
                actionButton {
                    onDecimal()
                } label: {
                    Text(CurrencyConstant.localDecimalSeparator)
                }

                numberButton("0")

                actionButton {
                    onErase()
                } label: {
                    Image(systemName: ConstantSystemImage.padDelete)
                }
            }

            HStack {
                
                if let onDelete {
                    Button(action: onDelete) {
                        //Label(.alertOptionDelete, systemImage: )
                        Text(.alertOptionDelete)
                            .frame(maxWidth: .infinity)
                            .frame(height: actionButtonHeight)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.alert)
                }
                    
                
                Button(action: onClear) {
                    Label(.selectorClear, systemImage: ConstantSystemImage.padClear)
                        .frame(maxWidth: .infinity)
                        .frame(height: actionButtonHeight)
                }
                .buttonStyle(.glass)

                
                Button(action: onConfirm) {
                    Label(.buttonSave, systemImage: ConstantSystemImage.checkmark)
                        .frame(maxWidth: .infinity)
                        .frame(height: actionButtonHeight)
                }
                .buttonStyle(.glassProminent)
            }
        }
    }

    private func numberButton(_ digit: String) -> some View {
        Button {
            onDigit(digit)
        } label: {
            Text(digit)
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .frame(height: numberButtonHeight)
                .contentShape(Rectangle())
        }
        //.buttonStyle(.glass)
        //.contentShape(RoundedRectangle(cornerRadius: 20))
        .buttonStyle(.plain)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private func actionButton<Content: View>(action: @escaping () -> Void, @ViewBuilder label: () -> Content) -> some View {
        Button(action: action) {
            label()
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: numberButtonHeight)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var valor = ""
    
    Text(valor)
    
    TransactionNumberPad { item in
        
    } onDecimal: {
        
    } onErase: {
        
    } onClear: {
        
    } onConfirm: {
        
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    TransactionNumberPad { item in
        
    } onDecimal: {
        
    } onErase: {
        
    } onClear: {
        
    } onConfirm: {
        
    } onDelete: {
        
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
