//
//  PickerGeneral.swift
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
struct PickerGeneral<E>: UIViewRepresentable where E: CaseIterable & RawRepresentable & Hashable, E.RawValue == String {
    
    @Binding var selection: E

    // UIViewRepresentable
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: E.allCases.map { $0.rawValue.capitalized })

        control.addTarget(context.coordinator,
                          action: #selector(Coordinator.valueChanged(_:)),
                          for: .valueChanged)

        // Fuente aplicada a todos los estados
        let attributeNormal: [NSAttributedString.Key : Any] = [.font: Font.montserratToUIFont(.light),
                                                               .foregroundColor: UIColor(Color.disabledForeground)]
        
        let attributeSelected: [NSAttributedString.Key : Any] = [.font: Font.montserratToUIFont(.regular),
                                                                 .foregroundColor: UIColor(Color.textFieldForeground)]

        
        control.setTitleTextAttributes(attributeNormal, for: .normal)
        control.setTitleTextAttributes(attributeSelected, for: .selected)
        
        control.selectedSegmentTintColor = UIColor(Color.textFieldBackground)
        control.backgroundColor = UIColor(Color.textFieldBackground)
        
        return control
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = Array(E.allCases).firstIndex(of: selection) ?? .zero
    }

    // Coordinator
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject {
        private let parent: PickerGeneral
        init(_ parent: PickerGeneral) { self.parent = parent }

        @objc func valueChanged(_ sender: UISegmentedControl) {
            let all = Array(E.allCases)
            if sender.selectedSegmentIndex < all.count {
                parent.selection = all[sender.selectedSegmentIndex]
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedValue: AccountType = .general
    
    VStack {
        PickerGeneral(selection: $selectedValue)
    }
}
