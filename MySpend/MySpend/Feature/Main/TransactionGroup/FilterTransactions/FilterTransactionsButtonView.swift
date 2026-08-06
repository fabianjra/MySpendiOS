//
//  FilterTransactionsButtonView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

struct FilterTransactionsButtonView: ToolbarContent {
    
    @ObservedObject var viewModel: TransactionViewModel
    @State private var showFiltersView: Bool = false
    
    @AppStorage(UserDefaultsKeys.filterAccountSelected.rawValue,
                store: UserDefaultsManager.userDefaults)
    private var filterAccountSelectedData: Data = Data()
    
    
    
    //@ToolbarContentBuilder
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    //withAnimation {
                    viewModel.showFilter.toggle()
                    //}
                } label: {
                    Image.filter
                        .foregroundStyle(.textPrimaryForeground)
                        .padding(ConstantViews.paddingSmall)
                        .background(viewModel.showFilter ? Capsule().fill(.primaryTop) : nil)
                    //.animation(nil, value: UUID()) //otra manera de desabilitar la animacion.
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                
                
                if viewModel.showFilter {
                    Button {
                        showFiltersView = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(.filterTitleDescription)
                                    .textStyle(size: .medium)
                                
                                Text(getTextDescription)
                                    .textStyle(color: viewModel.selectedAccountsFilter.isEmpty ? .textPrimaryForeground : .primaryTop,
                                                        size: .mediumSmall,truncateMode: .tail)
                                
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: ConstantFrames.filterMaxWidth)
                    }
                    .frame(maxWidth: ConstantFrames.filterMaxWidth)
                    .contentShape(Rectangle()) //Para detectar el touch en todo el espacio disponible.
                    //.matchedTransitionSource(id: viewModel.transitionFilters, in: namesapce)
                }
            }
            .popover(isPresented: $showFiltersView) {
                NavigationStack {
                    FilterTransactionsView(viewModel: viewModel)
                        .presentationDetents([.medium, .large])
                }
//                .navigationTransition(
//                    .zoom(sourceID: viewModel.transitionFilters, in: namesapce)
//                )
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
        if viewModel.favoriteSelected {
            return .filterAccountFavorites
        }

        switch viewModel.selectedAccountsFilter.count {
            
        case .zero:
            return .filterAccountNone
            
        case 1:
            return LocalizedStringResource(stringLiteral: viewModel.selectedAccountsFilter.first?.name ?? "")
            
        case viewModel.allAccounts.count:
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

        // Configuracion correcta para usar @AppStorage con preview:
        //UserDefaultsManager.userDefaults.set([], forKey: UserDefaultsKeys.filterAccountSelected.rawValue)
    }
    
    @StateObject private var viewModel = TransactionViewModel()
    @State private var showFiltersView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Accounts selected:").bold()
            
            ForEach(Array(viewModel.selectedAccountsFilter).sorted(by: { $0.name < $1.name }), id: \.id) { item in
                Text(item.name)
            }
        }
        .toolbar {
            FilterTransactionsButtonView(viewModel: viewModel)
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
