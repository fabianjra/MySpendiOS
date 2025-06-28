//
//  ContentView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/6/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //@Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Category.dateCreated, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Category>
    
    @StateObject private var viewModel: ContentViewModel
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: ContentViewModel(viewContext: viewContext))
    }

//    private var categoryManager: CategoryManager {
//        CategoryManager(viewContext: PersistenceController.shared.container.viewContext)
//    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories) { item in
                    NavigationLink {
                        Text("Item at \(item.dateCreated, formatter: itemFormatter)")
                    } label: {
                        Text(item.dateCreated, formatter: itemFormatter)
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
            viewModel.fectchCategories()
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.addNewCategory(CategoryModel())
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            // FORMA 1:
//            offsets.map { items[$0] }.forEach { item in
//                categoryManager.deleteCategory(withItem: item)
//            }
            
            // FORMA 2:
            viewModel.deleteCategory(at: offsets, from: viewModel.categories)
            //try? categoryManager.deleteCategory(at: offsets, from: viewModel.categories)
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
    ContentView(viewContext: PersistenceController.preview.container.viewContext)
        //.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
