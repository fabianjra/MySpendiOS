//
//  FilterTransactionsButtonView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

struct FilterTransactionsToolbarBottom: ToolbarContent {
    
    @Binding var showFilters: Bool
    
    @Environment(AccountManager.self) private var accountManager

    var body: some ToolbarContent {
        
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    accountManager.isFilterActive.toggle()
                } label: {
                    Image.filter
                        .foregroundStyle(.textPrimaryForeground)
                        .padding(ConstantViews.paddingSmall)
                        .background(
                            accountManager.isFilterActive ?
                            Capsule().fill(Color.accentColor.opacity(ConstantColors.opacityHigh)) : nil
                        )
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                
                
                if accountManager.isFilterActive {
                    Button {
                        showFilters = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(.filterTitleDescription)
                                    .font(.medium)
                                
                                Text(getTextDescription)
                                    .foregroundStyle(accountManager.selectedAccountsToFilterByID.isEmpty ?
                                        .textPrimaryForeground : .accentColor)
                                    .font(.small)
                                    .truncationMode(.tail)
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
        if accountManager.showOnlyFavorites {
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

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .empty, isFilterActive: Bool = false) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        AccountManager.shared.isFilterActive = isFilterActive
    }
    
    @State private var previewFilter = AccountManager.shared
    @State private var showFilters = false
    
    var body: some View {
        VStack {
            Text("Accounts selected:").bold()
            
            ForEach(previewFilter.sortedAccounts.filter { previewFilter.selectedAccountsToFilterByID.contains($0.id)}) { item in
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
        .environment(previewFilter)
    }
}

#Preview("Normal filtrado \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper(.normal, isFilterActive: true)
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}

#Preview("Normal sin filtrado \(Previews.localeEN)") {
    NavigationStack {
        previewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeEN))
    }
}
