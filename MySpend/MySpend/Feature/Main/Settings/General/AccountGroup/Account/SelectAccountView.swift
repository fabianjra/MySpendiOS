//
//  SelectAccountModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct SelectAccountView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(AccountManager.self) private var manager
    
    @Binding var selectedAccount: AccountModel
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            List {
                if manager.sortedAccounts.isEmpty {
                    
                    Text(.accountsEmpty)
                        .foregroundStyle(.secondary)
                    
                } else {
                    ForEach(manager.sortedAccounts) { item in
                        HStack {
                            let icon = item.icon.getIconFromSFSymbol
                            
                            if let image = icon {
                                image
                                    .font(.title3)
                            }
                            
                            Button(item.name) {
                                selectedAccount = item
                                dismiss()
                            }
                            .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            if item.id == manager.defaultAccount?.id {
                                Text(.accountsDefault)
                                    .foregroundStyle(Color.secondary)
                                    .fontWeight(.light)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .animation(.default, value: manager.sortedAccounts)
            
            .navigationTitle(.accountsTitle)
            .navigationSubtitle(.accountsSelectSubtitle)
            
            .presentationDetents([.medium, .large], selection: $selectedDetent)
            .presentationBackground {
                if selectedDetent == .large {
                    Color.backgroundGradient
                }
            }
            
            .toolbar {
                
                ToolbarItemGroup(placement: .primaryAction) {
                    Menu(.menuOptionsTitle, systemImage: ConstantSystemImage.options) {
                        MenuOrderAccount()
                    }
                    .menuOrder(.fixed)
                    .disabled(manager.sortedAccounts.isEmpty)
                }

                
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, local: String = Previews.localeES_CR) {
        UserDefaultsManager.defaultAccountID = MockCDConstants.mainAccountID
        
        _manager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        self.local = local
    }
    
    var local: String
    
    @State var manager = AccountManager.shared
    @State var show: Bool = false
    @State var model = AccountModel()
    
    var body: some View {
        VStack {
            Button("Show") {
                show = true
            }
        }
        .sheet(isPresented: $show) {
            SelectAccountView(selectedAccount: $model)
        }
        .onAppear {
            show = true
        }
        .environment(manager)
        .environment(\.locale, .init(identifier: local))
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper(.normal, local: Previews.localeES_CR)
}

#Preview("Saturated \(Previews.localeEN)") {
    previewWrapper(.saturated, local: Previews.localeEN)
}

#Preview("Empty \(Previews.localeES)") {
    previewWrapper(.empty, local: Previews.localeES)
}
