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
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(CategoryIcons.allCases) { icon in
                        VStack {
                            Section {
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
                                                .font(.title)
                                                .tint(.primary)
                                        }
                                    }
                                }
                            } header: {
                                Text(icon.rawValue)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Color.backgroundGradient)
            .ignoresSafeArea(.all, edges: .bottom)
            
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select icon")
        }
    }
}

#Preview {
    @Previewable @State var showModal: Bool = true
    @Previewable @State var selectedIcon = ""
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            Text("Icono: \(selectedIcon)")
            
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
