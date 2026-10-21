//
//  MenuOrderAccount.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/10/26.
//

import SwiftUI

struct MenuOrderAccount: View {
    
    @Environment(AccountManager.self) private var accountManager
    
    var body: some View {
        
        @Bindable var accountManagerBind = accountManager
        
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
                        accountManager.resetSort()
                    } label: {
                        Text(.sortByDefault)
                    }
                }
                
            }
            
        } label: {
            Label(.sortTitle, systemImage: ConstantSystemImage.arrowUpDown)
            
            Text(accountManager.sortSelection.sortBy.localized)
        }
    }
}

#Preview {
    @Previewable @State var accountManager = AccountManager.shared
    
    MenuOrderAccount()
        .environment(accountManager)
}
