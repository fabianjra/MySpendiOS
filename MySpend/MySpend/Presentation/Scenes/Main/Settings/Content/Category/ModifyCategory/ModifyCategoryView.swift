//
//  ModifyCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct ModifyCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ModifyCategoryViewModel
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: "Modify category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Modify the category details",
                            showLeadingAction: false,
                            showTrailingAction: true) { dismiss() }
                .padding(.vertical)
            
            
            // MARK: SEGMENT
            VStack {
                PickerSegmented(selection: $viewModel.model.categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldCategoryName(text: $viewModel.model.name,
                                      errorMessage: $viewModel.errorMessage)
                .onSubmit { process() }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: viewModel.model.icon, actionClear: {
                    viewModel.model.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button("Modify") {
                    process()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                
                //TODO: Cambiar estilo de boton por uno solamente bordes pintados.
                Button("Delete") {
                    viewModel.showAlert = true
                }
                .buttonStyle(ButtonPrimaryStyle(color: [Color.warning],isLoading: $viewModel.isLoading))
                .padding(.vertical)
                .alert("Delete category", isPresented: $viewModel.showAlert) {
                    Button("Delete", role: .destructive) { delete() }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Want to delete this category? \n This action cannot be undone.")
                }
                
                
                TextError(message: viewModel.errorMessage)
            }
        }
        .disabled(viewModel.isLoading)
        .sheet(isPresented: $viewModel.showIconsModal) {
            modal
        }
    }
    
    //TODO: Sacar a vista separada para ser reutilizada por New and Modify category.
    var modal: some View {
        NavigationStack {
            FormContainer(addPading: false, scrollable: true, showsIndicators: false, backgroundCenter: .center) {
                
                ForEach(Icons.allCases, id: \.self) { icon in
                    IconListView(icon: icon) { icon in
                        selectIcon(icon)
                    }
                    .padding(.top)
                    .padding(.bottom)
                }
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        viewModel.showIconsModal = false
                    } label: {
                        Image.xmarkCircle
                            .resizable()
                            .frame(width: FrameSize.width.headerButton,
                                   height: FrameSize.height.headerButton)
                            .font(.montserrat(size: .bigXXL))
                            .foregroundColor(Color.textPrimaryForeground)
                            .fontWeight(.ultraLight)
                    }
                    .padding()
                    .padding(.top)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .overlay(
                Rectangle()
                    .fill(Color.backgroundFormDark)
                    .frame(height: ConstantFrames.toolbarNavigationBarHeight)
                    .edgesIgnoringSafeArea(.top)
                    .shadow(color: Color.backgroundFormDark.opacity(ConstantColors.opacityToolbarNavigationBar),
                            radius: ConstantRadius.shadow,
                            y: ConstantRadius.shadowToolbarNavigationBarY)
                , alignment: .top
            )
        }
        .presentationCornerRadius(ConstantRadius.cornersModal)
        .presentationDetents([.large])
    }
    
    private func selectIcon(_ icon: String) {
        viewModel.model.icon = icon
        viewModel.showIconsModal = false
    }
    
    private func process() {
        Task {
            let result = await viewModel.modifyCategory()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func delete() {
        Task {
            let result = await viewModel.deleteCategory()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("Add new category") {
    VStack {
        let viewmodel = ModifyCategoryViewModel(model: CategoryModel(id: "",
                                                                     icon: "envelope",
                                                                     name: "Categoria sample",
                                                                     categoryType: .income))
        ModifyCategoryView(viewModel: viewmodel)
    }
}
