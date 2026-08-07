//
//  FilterTransactionsButtonView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

struct FilterTransactionsButtonView: ToolbarContent {
    
    @Binding var allAccounts: [AccountModel]
    @State private var showFiltersView: Bool = false
    
    private let filters = FilterCenter.shared
    
    //@ToolbarContentBuilder
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    //withAnimation {
                    //viewModel.showFilter.toggle()
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
                    FilterTransactionsView(allAccounts: $allAccounts)
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
        
        switch filters.selectedAccountsFilter.count {
            
        case .zero:
            return .filterAccountNone
            
        case 1:
            return LocalizedStringResource(stringLiteral: filters.selectedAccountsFilter.first?.name ?? "")
            
        case allAccounts.count:
            return .filterAccountAll
            
        default:
            return .filterAccountSomeAccounts
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        UserDefaultsManager.userDefaults = .preview
    }
    
    @StateObject private var viewModel = TransactionViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Accounts selected:").bold()
            
            ForEach(Array(FilterCenter.shared.selectedAccountsFilter).sorted(by: { $0.name < $1.name }), id: \.id) { item in
                Text(item.name)
            }
        }
        .toolbar {
            FilterTransactionsButtonView(allAccounts: $viewModel.allAccounts)
        }
        .task {
            await viewModel.activateObservers()
        }
    }
}

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}
