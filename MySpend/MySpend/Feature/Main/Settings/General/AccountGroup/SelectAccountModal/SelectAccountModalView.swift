//
//  SelectAccountModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct SelectAccountModalView: View {
    
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
                
                if sortedAccounts.isEmpty {
                    NoContentView(title: "Empty", entity: "Account")
                } else {
                    List {
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
                    .scrollContentBackground(.hidden)
                    .animation(.default, value: sortSelection)
                }
            }
            .navigationTitle(.accountsTitle)
            .navigationSubtitle(.accountsSelectSubtitle)
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .presentationDetents([.medium, .large], selection: $selectedDetent)
            .presentationBackground {
                if selectedDetent == .large {
                    Color.backgroundGradient
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

#Preview("Normal \(Previews.localeES_CR)") {
    @Previewable @State var showModal = true
    @Previewable @State var model = AccountModel()
    
    ZStack(alignment: .top) {
        Color.backgroundGradient
        VStack {
            Spacer()
            Text("Model selected: \(model.name)")
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        SelectAccountModalView(selectedModel: $model,
                               allAccounts: FilterCenter.shared.allAccounts)
            
    }
    .onAppear {
        showModal = true
        CoreDataUtilities.shared.mockDataType = .normal
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
