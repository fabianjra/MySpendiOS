//
//  TEST_TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//
    
import SwiftUI
import CoreData

struct TEST_TransactionView: View {
    @StateObject private var viewModel: TEST_TransactionViewModel
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: TEST_TransactionViewModel(viewContext: viewContext))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.transactions) { item in
                    NavigationLink {
                        VStack(alignment: .leading) {
                            Text("Date created: \(item.dateCreated, formatter: itemFormatter)")
                            Text("Amount: \(item.amount)")
                            Text("Notes: \(item.notes)")
                            
                            Text("Category name: \(item.category.name)")
                            Text("Category type: \(item.category.type.rawValue)")
                            
                            Text("Account name: \(item.account.name)")
                            Text("Account type: \(item.account.type.rawValue)")
                        }
                    } label: {
                        VStack {
                            Text("Notes: \(item.notes)")
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
            viewModel.addNewItem(TransactionModel())
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            // FORMA 1:
            offsets.map { viewModel.transactions[$0] }.forEach { item in
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
    TEST_TransactionView(viewContext: MocksEntities.preview.container.viewContext)
}
