//
//  TEST_AccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import SwiftUI
import CoreData

struct TEST_AccountView: View {
    @StateObject private var viewModel: TEST_AccountViewModel
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: TEST_AccountViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.accounts) { item in
                    NavigationLink {
                        VStack {
                            Text("Date created: \(item.dateCreated, formatter: itemFormatter)")
                            Text("Type: \(item.type.rawValue)")
                            Text("Name: \(item.name)")
                        }
                    } label: {
                        VStack {
                            Text("Name: \(item.name)")
                            Text(item.dateCreated, formatter: itemFormatter)
                        }
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .onAppear {
            viewModel.fetchAll()
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.addNewItem(AccountModel())
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            // FORMA 1:
            offsets.map { viewModel.accounts[$0] }.forEach { item in
                viewModel.delete(item)
            }
            
            // FORMA 2:
            //viewModel.delete(at: offsets, from: viewModel.accounts)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    TEST_AccountView(viewContext: MocksEntities.preview.container.viewContext)
}
