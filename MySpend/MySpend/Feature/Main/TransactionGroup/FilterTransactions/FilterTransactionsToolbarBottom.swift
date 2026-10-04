//
//  FilterTransactionsButtonView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

struct FilterTransactionsToolbarBottom: ToolbarContent {
    
    @Binding var showFilters: Bool
    
    @Environment(FilterCenter.self) private var filterCenter

    var body: some ToolbarContent {
        
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    filterCenter.isFilterActive.toggle()
                } label: {
                    Image.filter
                        .foregroundStyle(.textPrimaryForeground)
                        .padding(ConstantViews.paddingSmall)
                        .background(
                            filterCenter.isFilterActive ?
                            Capsule().fill(Color.accentColor.opacity(ConstantColors.opacityHigh)) : nil
                        )
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                
                
                if filterCenter.isFilterActive {
                    Button {
                        showFilters = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(.filterTitleDescription)
                                    .font(.medium)
                                
                                Text(getTextDescription)
                                    .foregroundStyle(filterCenter.selectedAccountsFilter.isEmpty ?
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
        if filterCenter.showOnlyFavorites {
            return .filterAccountFavorites
        }
        
        let selectedAccounts = filterCenter.selectedAccountsFilter
        
        if selectedAccounts.isEmpty {
            return .filterAccountNone
        }
        
        if selectedAccounts.count == filterCenter.allAccounts.count {
            return .filterAccountAll
        }
        
        if selectedAccounts.count == 1,
           let accountID = selectedAccounts.first,
           let account = filterCenter.allAccounts.first(where: { $0.id == accountID }) {
            return LocalizedStringResource(stringLiteral: account.name)
        }
        
        return .filterAccountSomeAccounts
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .empty, isFilterActive: Bool = false) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        FilterCenter.shared.isFilterActive = isFilterActive
    }
    
    @State private var filterCenter = FilterCenter.shared
    @State private var showFilters = false
    
    var body: some View {
        VStack {
            Text("Accounts selected:").bold()
            
            ForEach(FilterCenter.shared.allAccounts.filter { FilterCenter.shared.selectedAccountsFilter.contains($0.id)}) { item in
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
        .environment(filterCenter)
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
