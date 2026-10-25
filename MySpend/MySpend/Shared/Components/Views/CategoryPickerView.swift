//
//  PickerView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct CategoryPickerView: UIViewRepresentable {
    
    @Binding var selection: CategoryType
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl()
        
        for (index, type) in CategoryType.allCases.enumerated() {
            control.insertSegment(withTitle: localizedTitle(for: type, locale: context.environment.locale),
                                  at: index,
                                  animated: false)
        }
        
        control.addTarget(context.coordinator,
                          action: #selector(Coordinator.valueChanged(_:)),
                          for: .valueChanged)
        
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        context.coordinator.selection = $selection
        
        let types = CategoryType.allCases
        
        uiView.selectedSegmentIndex = types.firstIndex(of: selection) ?? UISegmentedControl.noSegment
        
        uiView.selectedSegmentTintColor = UIColor(selection == .expense ? Color.alert : Color.accentColor)
        
        uiView.isEnabled = context.environment.isEnabled
        
        // Update titles when the application's locale changes.
        for (index, type) in types.enumerated() {
            uiView.setTitle(localizedTitle(for: type, locale: context.environment.locale),forSegmentAt: index)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }
    
    // MARK: - LOCALIZATION
    
    private func localizedTitle(for type: CategoryType, locale: Locale) -> String {
        var resource = type.localized
        resource.locale = locale
        
        return String(localized: resource)
    }
    
    // MARK: - COORDINATOR
    
    final class Coordinator: NSObject {
        
        var selection: Binding<CategoryType>
        
        init(selection: Binding<CategoryType>) {
            self.selection = selection
        }
        
        @objc func valueChanged(_ sender: UISegmentedControl) {
            let types = CategoryType.allCases
            let index = sender.selectedSegmentIndex
            
            guard types.indices.contains(index) else {
                return
            }
            
            selection.wrappedValue = types[index]
        }
    }
}

#Preview(Previews.localeES) {
    @Previewable @State var categoryType: CategoryType = .expense
    
    CategoryPickerView(selection: $categoryType)
        .environment(\.locale, Locale(identifier: Previews.localeES))
}
