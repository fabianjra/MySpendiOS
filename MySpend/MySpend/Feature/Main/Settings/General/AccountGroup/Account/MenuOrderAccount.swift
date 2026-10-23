//
//  MenuOrderAccount.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/10/26.
//

import SwiftUI

struct MenuOrderAccount: View {
    
    @Environment(AccountManager.self) private var manager
    
    var body: some View {
        
        @Bindable var accountManagerBind = manager
        
        Menu {
            Section {
                Picker(.sortTitle, selection: $accountManagerBind.sortSelection.sortBy) {
                    ForEach(AccountSortOption.allCases, id: \.self) { sortBy in
                        Text(sortBy.localized)
                            .tag(sortBy)
                    }
                }
                
            }
            
            Section {
                Picker(.sortTitle, selection: $accountManagerBind.sortSelection.order) {
                    ForEach(SortOrder.allCases, id: \.self) { order in
                        Text(order.localized)
                            .tag(order)
                    }
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Button(role: .destructive) {
                        manager.resetSort()
                    } label: {
                        Text(.sortByDefault)
                    }
                }
                
            }
            
        } label: {
            Label(.sortTitle, systemImage: ConstantSystemImage.arrowUpDown)
            
            Text(manager.sortSelection.sortBy.localized)
        }
    }
}

#Preview {
    @Previewable @State var manager = AccountManager.shared
    
    MenuOrderAccount()
        .environment(manager)
}
