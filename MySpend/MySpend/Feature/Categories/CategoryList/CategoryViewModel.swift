//
//  CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/10/26.
//

import Observation

@Observable
final class CategoryViewModel {
    
    var selectedCategories = Set<CategoryModel>()
    var selectedType = CategoryType.expense
    
    var showCreateCategory = false
    
    var showUpdateCagatory = false
    var categoryToUpdate = CategoryModel()
    
    var showAlertDelete = false
    var categoryToDelete: CategoryModel?

    func toggleCategorySelection(_ category: CategoryModel) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}
