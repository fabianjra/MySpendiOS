//
//  SelectAccountModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct SelectAccountView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedModel: AccountModel
    var allAccounts: [AccountModel]
    
    private var sortedAccounts: [AccountModel] {
        allAccounts.sortedAccounts(by: sortSelection)
    }
    
    @State private var sortSelection = UserDefaultsManager.sortAccounts {
        didSet {
            UserDefaultsManager.sortAccounts = sortSelection
        }
    }
    
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            VStack {
                
                RowLCTCointainer(leadingContent: {
                    MenuContainer {
                        Section("Sorted by: \(sortSelection.rawValue)") {
                            sortButton(for: .byNameAz)
                            sortButton(for: .byCreationNewest)
                        }
                        
                        Section {
                            Button {
                                UserDefaultsManager.removeValue(for: .sortAccounts)
                                sortSelection = UserDefaultsManager.sortAccounts
                            } label: {
                                Label.restoreSelection
                                    .foregroundStyle(Color.alert, Color.alert)
                            }
                        }
                    }
                })
                .padding(.horizontal)
                
                List {
                    if sortedAccounts.isEmpty {
                        Text(.accountsEmpty)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(sortedAccounts) { item in
                            HStack {
                                let icon = item.icon.getIconFromSFSymbol
                                
                                if let image = icon {
                                    image
                                        .frame(width: FrameSize.width.iconCategoryList,
                                               height: FrameSize.height.iconCategoryList)
                                }
                                
                                Button(item.name) {
                                    selectedModel = item
                                    dismiss()
                                }
                                .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .animation(.default, value: sortSelection)
            }
            .navigationTitle(.accountsTitle)
            //.navigationSubtitle(.accountsSelectSubtitle)
            .navigationBarTitleDisplayMode(.inline)
            
            .presentationDetents([.medium, .large], selection: $selectedDetent)
            .presentationBackground {
                if selectedDetent == .large {
                    Color.backgroundGradient
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sortButton(for sortingOption: SortAccounts) -> some View {
        Button {
            if sortSelection == sortingOption {
                sortSelection = sortingOption.toggle
            } else {
                sortSelection = sortingOption
            }
            
        } label: {
            sortSelection == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .empty, local: String = Previews.localeES_CR) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        self.local = local
    }
    var local: String
    
    @State var show: Bool = false
    @State var model = AccountModel()
    
    var body: some View {
        VStack {
            Button("Show") {
                show = true
            }
        }
        .sheet(isPresented: $show) {
            SelectAccountView(selectedModel: $model,
                              allAccounts: FilterCenter.shared.allAccounts)
        }
        .onAppear {
            show = true
        }
        .environment(\.locale, .init(identifier: local))
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper(.normal, local: Previews.localeES_CR)
}

#Preview(Previews.localeEN) {
    previewWrapper(.normal, local: Previews.localeEN)
}

#Preview("Empty \(Previews.localeES)") {
    previewWrapper(local: Previews.localeES)
}
