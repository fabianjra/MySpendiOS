//
//  FilterTransactionsButtonView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

struct FilterTransactionsToolbarBottom: ToolbarContent {
    
    let placement: ToolbarItemPlacement
    
    @State private var showFiltersView: Bool = false
    
    private let filters = FilterCenter.shared

    //@ToolbarContentBuilder
    var body: some ToolbarContent {
        
        ToolbarItem(placement: placement) {
            HStack {
                Button {
                    //withAnimation {
                    filters.isFilterActive.toggle()
                    //}
                } label: {
                    Image.filter
                        .foregroundStyle(.textPrimaryForeground)
                        .padding(ConstantViews.paddingSmall)
                        .background(filters.isFilterActive ? Capsule().fill(.primaryTop) : nil)
                    //.animation(nil, value: UUID()) //otra manera de desabilitar la animacion.
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                
                
                if filters.isFilterActive {
                    Button {
                        showFiltersView = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(.filterTitleDescription)
                                    .textStyle(size: .medium)
                                
                                Text(getTextDescription)
                                    .textStyle(color: filters.selectedAccountsFilter.isEmpty ? .textPrimaryForeground : .primaryTop,
                                               size: .mediumSmall,truncateMode: .tail)
                                
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: ConstantFrames.filterMaxWidth)
                    }
                    .frame(maxWidth: ConstantFrames.filterMaxWidth)
                    .contentShape(Rectangle()) //Para detectar el touch en todo el espacio disponible.
                }
            }
            .popover(isPresented: $showFiltersView) {
                NavigationStack {
                    FilterTransactionsView()
                        .presentationDetents([.medium, .large])
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
        if filters.showOnlyFavorites {
            return .filterAccountFavorites
        }
        
        let selectedAccounts = filters.selectedAccountsFilter
        
        if selectedAccounts.isEmpty {
            return .filterAccountNone
        }
        
        if selectedAccounts.count == filters.allAccounts.count {
            return .filterAccountAll
        }
        
        if selectedAccounts.count == 1,
           let accountID = selectedAccounts.first,
           let account = filters.allAccounts.first(where: { $0.id == accountID }) {
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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Accounts selected:").bold()
            
            ForEach(FilterCenter.shared.allAccounts.filter { FilterCenter.shared.selectedAccountsFilter.contains($0.id)}) { item in
                Text(item.name)
            }
        }
        .toolbar {
            FilterTransactionsToolbarBottom(placement: .bottomBar)
        }
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
