//
//  PickerView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

/**
 A generic segmented picker backed by `UISegmentedControl` that works with any `enum` whose cases are `String` raw values.
 
 The picker:
 * Builds one segment per case in `E.allCases`, using the capitalized `rawValue` as the title.
 * Applies `fontNormal` to the unselected state and `fontSelected` to the selected state via `setTitleTextAttributes`.
 * Keeps the SwiftUI `selection` binding in sync with the control’s `selectedSegmentIndex`.
 
 Type constraints:
 `E` must conform to `CaseIterable`, `RawRepresentable` (with `String`
 */
struct PickerView<E>: UIViewRepresentable where E: CaseIterable & RawRepresentable & Hashable & Localizable, E.RawValue == String {
    
    @Binding var selection: E
    var fontSize = Font.Sizes.medium

    // UIViewRepresentable
    func makeUIView(context: Context) -> UISegmentedControl {
        
        // Localizable no funciona en Preview por este codigo: String(localized: String.LocalizationValue(:))
        let items = E.allCases.map { $0.localized }
        
        let control = UISegmentedControl(items: items)

        control.addTarget(context.coordinator,
                          action: #selector(Coordinator.valueChanged(_:)),
                          for: .valueChanged)

        // Fuente aplicada a todos los estados
        let attributeNormal: [NSAttributedString.Key : Any] = [.font: Font.montserratToUIFont(.light, size: fontSize),
                                                               .foregroundColor: UIColor(Color.textPrimaryForeground)]
        
        let attributeSelected: [NSAttributedString.Key : Any] = [.font: Font.montserratToUIFont(.regular, size: fontSize),
                                                                 .foregroundColor: UIColor(Color.textPrimaryForeground)]

        
        control.setTitleTextAttributes(attributeNormal, for: .normal)
        control.setTitleTextAttributes(attributeSelected, for: .selected)
        
        control.selectedSegmentTintColor = UIColor(Color.textSecondaryForeground.opacity(ConstantColors.opacityHalf))
        control.backgroundColor = UIColor(Color.secondaryTop.opacity(0.2))
        
        return control
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = Array(E.allCases).firstIndex(of: selection) ?? .zero
        
        // Valida si debe aplicar colores dependiendo del tipo de enum
        if let accountType = selection as? AccountType {
            switch accountType {
            case .expenses: uiView.selectedSegmentTintColor = UIColor(Color.alert)
            case .incomes:  uiView.selectedSegmentTintColor = UIColor(Color.primaryBottom)
            case .general:  uiView.selectedSegmentTintColor = UIColor(Color.textSecondaryForeground.opacity(ConstantColors.opacityHalf))
            }
            
        } else if let categoryType = selection as? CategoryType {
            switch categoryType {
            case .expense: uiView.selectedSegmentTintColor = UIColor(Color.alert)
            case .income:  uiView.selectedSegmentTintColor = UIColor(Color.primaryBottom)
            }
            
        } else {
            uiView.selectedSegmentTintColor = UIColor(Color.textSecondaryForeground.opacity(ConstantColors.opacityHalf))
        }
    }

    // Coordinator
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject {
        private let parent: PickerView
        init(_ parent: PickerView) { self.parent = parent }

        @objc func valueChanged(_ sender: UISegmentedControl) {
            let all = Array(E.allCases)
            if sender.selectedSegmentIndex < all.count {
                parent.selection = all[sender.selectedSegmentIndex]
            }
        }
    }
}

#Preview("All \(Previews.localeES)") {
    @Previewable @State var accountType: AccountType = .general
    @Previewable @State var categoryType: CategoryType = .expense
    @Previewable @State var currencyType: CurrencySymbolType = .symbol
    @Previewable @State var dateTimeInterval: DateTimeInterval = .month
    
    VStack {
        PickerView(selection: $accountType)
        
        PickerView(selection: $categoryType)
        
        PickerView(selection: $currencyType)
        
        PickerView(selection: $dateTimeInterval)
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeES) {
    @Previewable @State var dateTimeInterval: DateTimeInterval = .month
    
    PickerView(selection: $dateTimeInterval)
        .environment(\.locale, .init(identifier: Previews.localeES))
}
