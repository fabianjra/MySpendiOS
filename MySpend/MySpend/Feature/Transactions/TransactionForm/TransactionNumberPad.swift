//
//  TransactionNumberPad.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/11/26.
//

import SwiftUI

struct TransactionNumberPad: View {
    
    let onDigit: (String) -> Void
    let onDecimal: () -> Void
    let onDelete: () -> Void
    let onClear: () -> Void
    let onConfirm: () -> Void

    private let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"]
    ]
    
    private let numberButtonHeight: CGFloat = 64
    private let actionButtonHeight: CGFloat = 54

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
                    Text(CurrencyManager.localDecimalSeparator)
                }

                numberButton("0")

                actionButton {
                    onDelete()
                } label: {
                    Image(systemName: ConstantSystemImage.padDelete)
                }
            }

            HStack {
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
        }
        .buttonStyle(.glass)
    }

    private func actionButton<Content: View>(action: @escaping () -> Void, @ViewBuilder label: () -> Content) -> some View {
        Button(action: action) {
            label()
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: numberButtonHeight)
        }
        .buttonStyle(.glass)
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var valor = ""
    
    Text(valor)
    
    TransactionNumberPad { item in
        
    } onDecimal: {
        
    } onDelete: {
        
    } onClear: {
        
    } onConfirm: {
        
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    TransactionNumberPad { item in
        
    } onDecimal: {
        
    } onDelete: {
        
    } onClear: {
        
    } onConfirm: {
        
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
