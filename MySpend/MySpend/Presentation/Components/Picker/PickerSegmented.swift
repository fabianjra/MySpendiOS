//
//  PickerSegmented.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/24.
//

import SwiftUI

struct PickerSegmented: UIViewRepresentable {
    
    @Binding var selection: TransactionTypeEnum
    let segments: [TransactionTypeEnum]
    
    func makeUIView(context: Context) -> UISegmentedControl {
        
        let segmentedControl = UISegmentedControl(items: segments.map { $0.rawValue })
        segmentedControl.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return segmentedControl
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        
        uiView.selectedSegmentIndex = segments.firstIndex(of: selection) ?? 0
        
        uiView.selectedSegmentTintColor = UIColor(selection == .expense ?
            .warning : .primaryTrailing)
        
        uiView.setTitleTextAttributes([.font: Font.montserratToUIFont(.light),
                                       .foregroundColor: UIColor(.textPrimaryForeground)],
                                      for: .selected)
        
        uiView.setTitleTextAttributes([.font: Font.montserratToUIFont(.light),.foregroundColor: UIColor(.disabledForeground)],
                                      for: .normal)
        
        uiView.backgroundColor = UIColor(.textfieldBackground)
    }
    
    class Coordinator: NSObject {
        var parent: PickerSegmented
        
        init(parent: PickerSegmented) {
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
        PickerSegmented(selection: .constant(.expense), segments: TransactionTypeEnum.allCases)
        
        PickerSegmented(selection: .constant(.income), segments: TransactionTypeEnum.allCases)
    }
}
