//
//  FilterTransactionsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/4/26.
//

import SwiftUI

struct FilterTransactionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let filters = FilterCenter.shared
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            VStack { //Necesario si el contenedor es un NavistaionStack
                List {
                    if filters.allAccounts.isEmpty {
                        Text(.accountsEmpty)
                            .foregroundStyle(.secondary)
                        
                    } else {
                        Section {
                            ForEach(filters.allAccounts) { account in
                                HStack {
                                    Label(account.name, systemImage: account.icon)
                                        .foregroundStyle(.textPrimaryForeground)
                                    
                                    Spacer()
                                    
                                    Image(systemName: filters.selectedAccountsFilter.contains(account.id) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                        .resizable()
                                        .frame(width: FrameSize.height.iconRowList,
                                               height: FrameSize.width.iconRowList)
                                        .foregroundStyle(.primaryBottom)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    filters.toggleAccount(account)
                                }
                            }
                        } header: {
                            Text(.filterByAccount)
                                .fontWeight(.light)
                        }
                        
                        Section {
                            HStack {
                                Label(.filterByFavorite, systemImage: ConstantSystemImage.favoriteFill)
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                                
                                Image(systemName: filters.showOnlyFavorites ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.primaryBottom)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                filters.showOnlyFavorites.toggle()
                            }
                        } header: {
                            Text(.filterInclude)
                                .fontWeight(.light)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button {
                    filters.restoreFilter()
                } label: {
                    Label(.filterRestore, systemImage: ConstantSystemImage.arrowCounterClockwise)
                        .foregroundStyle(.textPrimaryForeground)
                }
            }
            // MARK: NAVIGATION
            .navigationTitle(.filters)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
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
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State var show: Bool = false
    
    var body: some View {
        VStack {
            Button("Show") {
                show = true
            }
        }
        .sheet(isPresented: $show) {
            FilterTransactionsView()
        }
        .onAppear {
            show = true
        }
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper(.normal)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    previewWrapper(.normal)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview("Empty \(Previews.localeES)") {
    previewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES))
}
