//
//  ContentView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/6/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.dateCreated, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Category>

    private var categoryManager: CategoryManager {
        CategoryManager(viewContext: viewContext)
    }
    
    var body: some View {
        
        Button("Test catch error") {
            let modelo = CategoryModel()
            CategoryManager(viewContext: viewContext).saveNewCategory(modelo)
        }
        
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.dateCreated!, formatter: itemFormatter)")
                    } label: {
                        Text(item.dateCreated!, formatter: itemFormatter)
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
    }

    private func addItem() {
        withAnimation {
            categoryManager.saveNewCategory(CategoryModel())
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            // FORMA 1:
//            offsets.map { items[$0] }.forEach { item in
//                categoryManager.deleteCategory(withItem: item)
//            }
            
            // FORMA 2:
            categoryManager.deleteCategory(at: offsets, from: items)
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
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
