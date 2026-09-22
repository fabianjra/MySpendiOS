//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @State private var viewModel = TransactionHistoryViewModel()
    @State private var toast = ToastViewModel()
    
    @Binding var transactionsLoaded: [TransactionModel]
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    
    private let filters = FilterCenter.shared

    
    // MARK: ALERTS (Solo manejadas dentro de la vista, no hacen nada en ViewModel)
    @State private var showAlertDelete = false
    
    
    // MARK: NAVIGATION
    @State private var showNewItemModal = false
    @State private var showSearchView = false
    @State private var modelToModify: TransactionModel?
    @State private var modelToDelete: TransactionModel?
    
    var body: some View {
        VStack {
            header
            
            if transactionsLoaded.isEmpty {
                TransactionsEmptyView()
            } else {
                transactionsList
            }
        }
        .padding(.horizontal)
        .navigationTitle(.titleHistoryView)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContent
        }
        .searchable(text: $viewModel.searchText, isPresented: $showSearchView)
        .searchToolbarBehavior(.minimize)
        .navigationBarBackButtonHidden(viewModel.isEditing)
        
        .sheet(isPresented: $showNewItemModal) {
            NavigationStack {
                AddModifyTransactionView(selectedDate: selectedDate)
            }
        }
        .sheet(item: $modelToModify) { model in
            NavigationStack {
                AddModifyTransactionView(model)
                    .onDisappear {
                        modelToModify = nil
                    }
            }
        }
        .background(Color.backgroundGradient)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .onAppear {
            filterTransactionsByDate()
        }
        .onChange(of: selectedDate) {
            filterTransactionsByDate()
        }
        .onChange(of: transactionsLoaded) {
            filterTransactionsByDate()
        }
        .onChange(of: dateTimeInterval) {
            filterTransactionsByDate()
        }
        .onChange(of: viewModel.sortTransactionsBy) {
            filterTransactionsByDate()
        }
        
        .toast(toast.response, isPresented: $toast.show)
    }
    
    private func filterTransactionsByDate() {
        viewModel.transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
                                                                                transactions: transactionsLoaded,
                                                                                for: dateTimeInterval,
                                                                                sortTransactions: viewModel.sortTransactionsBy)
    }
    
    
    // MARK: VIEWS
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            if viewModel.isEditing {
                if viewModel.selectedTransactions.count == viewModel.transactionsFiltered.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedTransactions = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedTransactions = Set(viewModel.transactionsFiltered)
                    }
                }
            }
        }
        
        ToolbarItem(placement: .title) {
            if viewModel.selectedTransactions.count == .zero {
                Text(.titleHistoryView)
                    .textStyle(size: .big)
            } else {
                Text(.selectorSelectedCountFemale(viewModel.selectedTransactions.count))
                    .textStyle(size: .medium)
            }
        }
        
        ToolbarItem(placement: .primaryAction) {
            if viewModel.isEditing {
                Button(role: .cancel) {
                    viewModel.selectedTransactions.removeAll()
                    viewModel.isEditing = false
                }
            } else {
                Button(.selectorSelect) {
                    viewModel.isEditing = true
                }
                .disabled(transactionsLoaded.isEmpty)
            }
        }
        
        
        // MARK: BOTTOM
        
        if viewModel.isEditing {
            
            ToolbarItem(placement: .bottomBar) {
                
                let shouldMarkAsFavorite = shouldMarkAsFavorite
                
                Button(shouldMarkAsFavorite ? .selectorFavorite : .selectorUnfavorite,
                       systemImage: shouldMarkAsFavorite ? ConstantSystemImage.favoriteFill : ConstantSystemImage.unfavoriteFill) {
                    
                    favoriteMultipleTransactions(newState: shouldMarkAsFavorite)
                }
                       .disabled(viewModel.selectedTransactions.isEmpty)
            }
            
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            
        } else {
            FilterTransactionsToolbarBottom()
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            DefaultToolbarItem(kind: .search, placement: .bottomBar) //TODO: Reparar: se pasa hacia arriba al editar.
        }
        
        ToolbarItem(placement: .bottomBar) {
            if viewModel.isEditing {
                Button(.selectorDelete, systemImage: ConstantSystemImage.trash) {
                    showAlertDelete = true
                }
                .disabled(viewModel.selectedTransactions.isEmpty)
                
            } else {
                Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem) {
                    showNewItemModal = true
                }
                .tint(.primaryTop)
            }
        }
    }
    
    private func sortButton(_ sortingOption: SortTransactions) -> some View {
        Button {
            if viewModel.sortTransactionsBy == sortingOption {
                viewModel.sortTransactionsBy = sortingOption.toggle
            } else {
                viewModel.sortTransactionsBy = sortingOption
            }
            
            viewModel.updateSelectedSort() // Updates the sort selection to store in UserDefaults.
        } label: {
            viewModel.sortTransactionsBy == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
        }
    }
    
    private var sortButtonResetToDefault: some View {
        Button {
            viewModel.resetSelectedSort()
        } label: {
            Label.restoreSelection
                .foregroundStyle(.alert, .alert)
        }
    }
    
    private var header: some View {
        //        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
        //                                  selectedDate: $selectedDate,
        //                                  isEditing: $viewModel.isEditing,
        //                                  showEditor: true,
        //                                  counterSelected: viewModel.selectedTransactions.count) {
        //
        //            viewModel.selectedTransactions.removeAll()
        
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: $viewModel.isEditing,
                                  showEditor: false, //TODO: Convertir a True para mostrar el Sort by. Eliminar la linea de arriba de edit.
                                  counterSelected: viewModel.selectedTransactions.count) {
        } actionTrailingEdit: {
            //showAlertDeleteMultiple = true
            
        } contentLeadingSort: {
            Section(.sortTitleDescription(viewModel.sortTransactionsBy.rawValue)) {
                sortButton(.byDateNewest)
                sortButton(.byAmountHigher)
                sortButton(.byCategoryNameAz)
            }
            
            // Reset the sort selection to default
            Section {
                sortButtonResetToDefault
            }
        }
    }
    
    private var transactionsList: some View {
        VStack {
            List {
                ForEach(viewModel.transactionsFiltered, id: \.self) { item in
                    VStack {
                        HStack {
                            if viewModel.isEditing {
                                Image(systemName: viewModel.selectedTransactions.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.alert)
                                    .transition(.scale.combined(with: .move(edge: .leading)))
                            }
                            
                            if let image = item.category.icon.getIconFromSFSymbol {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.width.iconInsideTextField,
                                           height: FrameSize.height.iconInsideTextField)
                                    .foregroundStyle(.textPrimaryForeground)
                            }
                            
                            Button("") {
                                if viewModel.isEditing {
                                    if viewModel.selectedTransactions.contains(item) {
                                        viewModel.selectedTransactions.remove(item)
                                    } else {
                                        viewModel.selectedTransactions.insert(item)
                                    }
                                } else {
                                    modelToModify = item
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                if item.notes.isEmptyOrWhitespace {
                                    Text(item.category.name)
                                        .textStyle
                                } else {
                                    Text(item.notes)
                                        .textStyle
                                }
                                
                                HStack {
                                    if filters.allAccounts.count > 1 {
                                        Text("\(item.account.name):")
                                            .textStyle(size: .small)
                                    }
                                    
                                    Text(item.dateTransaction.toStringShortLocale)
                                        .textStyle(size: .small)
                                }
                            }
                            
                            Spacer()
                            
                            Text(item.amount.convertAmountDecimalToString.addCurrencySymbol)
                                .textStyle(color: item.category.type == .income ? .primaryTop : .alert)
                            
                            if item.favorite {
                                Image(systemName: ConstantSystemImage.favoriteFill)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.primaryTop)
                                    .onTapGesture {
                                        favorite(item)
                                    }
                            }
                            
                            //Image.chevronRight
                            //.foregroundStyle(.textPrimaryForeground)
                        }
                        .alignmentGuide(.listRowSeparatorLeading) { _ in
                            //Removes the padding Leading in the RowSeparator.
                            return .zero
                        }
                        .alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
                            //Removes the padding Trailing in the RowSeparator.
                            return viewDimensions[.listRowSeparatorTrailing]
                        }
                    }
                    .frame(height: FrameSize.height.rowForListTransactionHistory)
                    .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                    //.listRowSeparatorTint(.textPrimaryForeground.opacity(ConstantColors.opacityHalf)) //Linea separadora
                    
                    // MARK: SWIPE ACTIONS:
                    
                    .swipeActions(edge: .trailing) {
                        if !viewModel.isEditing {
                            
                            Button("", systemImage: ConstantSystemImage.trash) {
                                modelToDelete = item
                                showAlertDelete = true
                            }
                            .tint(.alert)
                            
                            
                            Button("", systemImage: ConstantSystemImage.squareAndPencil) {
                                modelToModify = item
                            }
                            //.tint(.warning)
                            
                            if item.favorite == false {
                                Button("", systemImage: ConstantSystemImage.favoriteFill) {
                                    favorite(item)
                                }
                                .tint(.primaryTop)
                                
                            }
                        }
                    }
                    .contextMenu {
                        if !viewModel.isEditing {
                            
                            if item.favorite {
                                Button(.selectorUnfavorite, systemImage: ConstantSystemImage.unfavoriteFill) {
                                    favorite(item)
                                }
                                
                            } else {
                                Button(.selectorFavorite, systemImage: ConstantSystemImage.favoriteFill) {
                                    favorite(item)
                                }
                            }
                            
                            
                            Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                modelToModify = item
                            }
                            
                            
                            Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                                modelToDelete = item
                                showAlertDelete = true
                            }
                            .tint(.alert)
                        }
                    }
                    
                    .alert(.transactionDelete(viewModel.selectedTransactions.count), isPresented: $showAlertDelete) {
                        Button(.alertOptionDelete, role: .destructive) {
                            if viewModel.selectedTransactions.isEmpty {
                                delete()
                            } else {
                                deleteMltipleTransactions()
                            }
                        }
                        
                        Button(.alertOptionCancel, role: .cancel) { }
                    } message: {
                        Text(.transactionDeleteMessage(viewModel.selectedTransactions.count))
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .animation(.default, value: viewModel.transactionsFiltered.count)
            .animation(.default, value: viewModel.isEditing)
            .animation(.default, value: viewModel.sortTransactionsBy)
            
            TotalBalanceView(transactions: viewModel.transactionsFiltered, showTotalBalance: false)
        }
    }
    
    
    // MARK: FUNCTIONS
    
    /**
     Si todas las transacciones seleccionadas son favoritas, el botón debe quitarlas de favoritos.
     Si al menos una no es favorita, debe marcar todas como favoritas.
    */
    private var shouldMarkAsFavorite: Bool {
        if viewModel.selectedTransactions.isEmpty {
            return true
        }

        return !viewModel.selectedTransactions.allSatisfy(\.favorite)
    }
    
    private func favorite(_ model: TransactionModel) {
        Task {
            let response = await viewModel.favorite(model)
            
            if response.type == .error {
                toast.response = response
            }
        }
    }
    
    private func favoriteMultipleTransactions(newState: Bool) {
        Task {
            let response = await viewModel.favoriteMltiple(newState)
            
            if response.type == .error {
                toast.response = response
            }
        }
    }
    
    private func delete() {
        Task {
            defer {
                modelToDelete = nil
            }
            
            toast.response = await viewModel.delete(modelToDelete)
        }
    }
    
    private func deleteMltipleTransactions() {
        Task {
            toast.response = await viewModel.deleteMltiple()
        }
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @StateObject private var viewModel = TransactionViewModel()
    
    @State private var dateTimeInterval: DateTimeInterval = .month
    @State private var selectedDate: Date = .now
    
    var body: some View {
        TransactionHistoryView(transactionsLoaded: $viewModel.transactionsFiltered,
                               dateTimeInterval: $dateTimeInterval,
                               selectedDate: $selectedDate)
        .task {
            await viewModel.activateObservers()
        }
    }
}

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        PreviewWrapper(.normal)
            
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Random Saturated \(Previews.localeEN_US)") {
    NavigationStack {
        PreviewWrapper(.saturated)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN_US))
}

#Preview("Empty \(Previews.localeEN_US_POSIX)") {
    NavigationStack {
        PreviewWrapper()
    }
        .environment(\.locale, .init(identifier: Previews.localeEN_US_POSIX))
}
