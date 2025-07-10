//
//  PickerCategoryType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/24.
//

import SwiftUI

struct PickerCategoryType: UIViewRepresentable {
    
    @Binding var selection: CategoryType
    let segments: [CategoryType]
    
    func makeUIView(context: Context) -> UISegmentedControl {
        
        let segmentedControl = UISegmentedControl(items: segments.map { $0.rawValue })
        segmentedControl.addTarget(context.coordinator,
                                   action: #selector(Coordinator.valueChanged),
                                   for: .valueChanged)
        return segmentedControl
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        
        uiView.selectedSegmentIndex = segments.firstIndex(of: selection) ?? 0
        
        uiView.selectedSegmentTintColor = UIColor(selection == .expense ? Color.alert : Color.primaryTrailing)
        
        uiView.setTitleTextAttributes([.font: Font.montserratToUIFont(.light),
                                       .foregroundColor: UIColor(Color.textPrimaryForeground)],
                                      for: .selected)
        
        uiView.setTitleTextAttributes([.font: Font.montserratToUIFont(.light),
                                       .foregroundColor: UIColor(Color.disabledForeground)],
                                      for: .normal)
        
        uiView.backgroundColor = UIColor(Color.textFieldBackground)
    }
    
    class Coordinator: NSObject {
        var parent: PickerCategoryType
        
        init(parent: PickerCategoryType) {
            self.parent = parent
        }
        
        @objc func valueChanged(sender: UISegmentedControl) {
            let selectedIndex = sender.selectedSegmentIndex
            if let selectedType = parent.segments[safe: selectedIndex] {
                parent.selection = selectedType
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


#Preview {
    VStack {
        PickerCategoryType(selection: .constant(.expense), segments: CategoryType.allCases)
        
        PickerCategoryType(selection: .constant(.income), segments: CategoryType.allCases)
    }
}
