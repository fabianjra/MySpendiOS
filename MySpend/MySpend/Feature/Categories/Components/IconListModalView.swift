//
//  IconListModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct IconListModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedIcon: String
    
    var body: some View {
        NavigationStack {
            FormContainer(addPading: false, scrollable: true, showsIndicators: false, backgroundCenter: .center) {
                
                ForEach(CategoryIcons.allCases) { icon in
                    VStack {
                        SectionContainer(icon.rawValue, isInsideList: false, textSize: .body) {
                            
                            let columns = [
                                GridItem(.adaptive(minimum: ConstantViews.gridSpacing))
                            ]
                            
                            LazyVGrid(columns: columns, alignment: .center, spacing: ConstantViews.formSpacing) {
                                ForEach(icon.list, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
                                        dismiss()
                                    } label: {
                                        Image(systemName: icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: FrameSize.width.iconShowcase,
                                                   height: FrameSize.height.iconShowcase)
                                            .tint(Color.textPrimaryForeground)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .padding(.bottom)
                }
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select icon")
        }
        .presentationDetents([.large])
    }
}

#Preview {
    @Previewable @State var showModal: Bool = true
    @Previewable @State var selectedIcon = ""
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain("Icono: \(selectedIcon)")
            
            Image(systemName: selectedIcon)
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }
    .sheet(isPresented: $showModal) {
        IconListModalView(selectedIcon: $selectedIcon)
    }
}
