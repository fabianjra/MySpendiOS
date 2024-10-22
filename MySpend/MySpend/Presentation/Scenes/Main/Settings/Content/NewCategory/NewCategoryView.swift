//
//  NewCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct NewCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = NewCategoryViewModel()
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: "New category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Enter the new category details",
                            showLeadingAction: false,
                            showTrailingAction: true) { dismiss() }
            .padding(.vertical)
            
            
            // MARK: SEGMENT
            
            VStack {
                PickerSegmented(selection: $viewModel.model.categoryType,
                                segments: TransactionType.allCases)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            
            VStack {
                TextFieldCategoryName(text: $viewModel.model.name,
                                      errorMessage: $viewModel.errorMessage)
                .onSubmit { process() }
                
                //TODO: Agregar estilo rectangular con icono de eliminar el icono elegido.
                HStack {
                    TextPlain(message: "Icon:", size: .big)
                    
                    Image(systemName: viewModel.model.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: FrameSize.width.iconSelect,
                               height: FrameSize.height.iconSelect)
                        .padding()
                    
                    Button {
                        viewModel.model.icon = ""
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
                .onTapGesture {
                    viewModel.showIconsModal = true
                }
            }
            
            
            // MARK: BUTTONS
            
            VStack {
                Button("Accept") {
                    process()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                

                TextError(message: viewModel.errorMessage)
            }
        }
        .sheet(isPresented: $viewModel.showIconsModal) {
            modal
        }
    }
    
    var modal: some View {
        NavigationStack {
            ContentContainer(addPading: false) {
                
                NewCategoryModalContent(header: "Bills", arrayIcons: ConstantIcons.BillsFill) { icon in
                    selectIcon(icon)
                }
                .padding(.bottom)
                
                NewCategoryModalContent(header: "Food and Drink", arrayIcons: ConstantIcons.FoodDrinkFill) { icon in
                    selectIcon(icon)
                }
                .padding(.top)
                .padding(.bottom)
                
                NewCategoryModalContent(header: "Household", arrayIcons: ConstantIcons.HouseholdFill) { icon in
                    selectIcon(icon)
                }
                .padding(.top)
                .padding(.bottom)
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
            let result = await viewModel.addNewCategory()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("Add new category") {
    NewCategoryView()
}
