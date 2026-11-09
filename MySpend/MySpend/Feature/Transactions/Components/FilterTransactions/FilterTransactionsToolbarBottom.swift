//
//  FilterTransactionsButtonView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

struct FilterTransactionsToolbarBottom: ToolbarContent {
    
    @Binding var showFilters: Bool
    
    @Environment(TransactionManager.self) private var transactionManager
    @Environment(AccountManager.self) private var accountManager

    var body: some ToolbarContent {
        
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    transactionManager.isFilterActive.toggle()
                } label: {
                    Image.filter
                        .foregroundStyle(Color.primary)
                        .padding(ConstantViews.paddingSmall)
                        .background(transactionManager.isFilterActive
                                    ? Capsule().fill(Color.accentColor.opacity(0.7))
                                    : nil
                        )
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                
                
                if transactionManager.isFilterActive {
                    Button {
                        showFilters = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(.filterTitleDescription)
                                    .font(.callout)
                                
                                Text(getTextDescription)
                                    .foregroundStyle(accountManager.selectedAccountsToFilterByID.isEmpty ? Color.primary : .accentColor)
                                    .font(.footnote)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: ConstantFrames.filterMaxWidth)
                    }
                    .frame(maxWidth: ConstantFrames.filterMaxWidth)
                    .contentShape(Rectangle()) //Para detectar el touch en todo el espacio disponible.
                }
            }
        }
    }
    
    /**
     Permite obtener directamente un texto del string catalog en base a su llave en el resource.
     El struct `LocalizedStringResource(stringLiteral:` permite convertir un string a tipo string catalog resource.
     
     - Authors: Fabian Rodriguez
     
     - Date: August 2026
     */
    private var getTextDescription: LocalizedStringResource {
        if transactionManager.showOnlyFavorites {
            return .filterAccountFavorites
        }
        
        let selectedAccounts = accountManager.selectedAccountsToFilterByID
        
        if selectedAccounts.isEmpty {
            return .filterAccountNone
        }
        
        if selectedAccounts.count == accountManager.sortedAccounts.count {
            return .filterAccountAll
        }
        
        if selectedAccounts.count == 1,
           let accountID = selectedAccounts.first,
           let account = accountManager.sortedAccounts.first(where: { $0.id == accountID }) {
            return LocalizedStringResource(stringLiteral: account.name)
        }
        
        return .filterAccountSomeAccounts
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, isFilterActive: Bool = false) {
        _transactionManager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        
        transactionManager.isFilterActive = isFilterActive
    }
    
    @State var transactionManager: TransactionManager
    @State var accountManager: AccountManager
    
    @State private var showFilters = false
    
    var body: some View {
        VStack {
            Text(verbatim: "Accounts selected:")
            
            ForEach(accountManager.sortedAccounts.filter { accountManager.selectedAccountsToFilterByID.contains($0.id)}) { item in
                Text(item.name)
            }
        }
        .toolbar {
            FilterTransactionsToolbarBottom(showFilters: $showFilters)
            
            ToolbarSpacer(placement: .bottomBar)
        }
        .sheet(isPresented: $showFilters) {
            NavigationStack {
                FilterTransactionsView()
            }
        }
        .environment(transactionManager)
        .environment(accountManager)
    }
}

#Preview(Previews.localeES_CR) {
    NavigationStack {
        PreviewWrapper(.normal, isFilterActive: true)
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}

#Preview("Normal sin filtrado \(Previews.localeEN)") {
    NavigationStack {
        PreviewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeEN))
    }
}
