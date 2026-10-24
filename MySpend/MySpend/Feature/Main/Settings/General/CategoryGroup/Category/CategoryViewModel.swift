//
//  CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/10/26.
//

import Observation

@Observable
final class CategoryViewModel {
    
    //var showNewItemModel = false
    //var showUpdateCagatory = false
    var showAlertDelete = false

    var selectedCategories = Set<CategoryModel>()
    //var categoryToDelete: CategoryModel?
    //var categoryToUpdate = CategoryModel()
    
    func toggleCategorySelection(_ category: CategoryModel) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}
