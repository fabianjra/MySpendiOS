//
//  MenuOrderCategory.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/10/26.
//

import SwiftUI

struct MenuOrderCategory: View {
    
    @Environment(CategoryManager.self) private var manager
    
    var body: some View {
        
        @Bindable var managerBind = manager
        
        Menu {
            Section {
                Picker(.sortTitle, selection: $managerBind.sortSelection.sortBy) {
                    ForEach(CategorySortOption.allCases, id: \.self) { sortBy in
                        Text(sortBy.localized)
                            .tag(sortBy)
                    }
                }
                
            }
            
            Section {
                Picker(.sortTitle, selection: $managerBind.sortSelection.order) {
                    ForEach(SortOrder.allCases, id: \.self) { order in
                        Text(manager.sortSelection.sortBy.orderLocalized(order))
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
    @Previewable @State var manager = CategoryManager.shared
    
    MenuOrderCategory()
        .environment(manager)
}
