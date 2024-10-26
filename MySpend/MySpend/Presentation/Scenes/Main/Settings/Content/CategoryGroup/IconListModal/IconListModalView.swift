//
//  IconListModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct IconListModalView: View {
    
    @Binding var model: CategoryModel
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationStack {
            FormContainer(addPading: false, scrollable: true, showsIndicators: false, backgroundCenter: .center) {
                
                ForEach(CategoryIcons.allCases) { icon in
                    VStack {
                        SectionContainer(header: icon.rawValue, isInsideList: false, headerSize: .body) {
                            
                            let columns = [
                                GridItem(.adaptive(minimum: ConstantViews.gridSpacing))
                            ]
                            
                            LazyVGrid(columns: columns, alignment: .center, spacing: ConstantViews.formSpacing) {
                                ForEach(icon.list, id: \.self) { icon in
                                    Button {
                                        model.icon = icon
                                        showModal = false
                                    } label: {
                                        Image(systemName: icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: FrameSize.width.iconShowcase,
                                                   height: FrameSize.height.iconShowcase)
                                            .tint(Color.textPrimaryForeground)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .padding(.bottom)
                }
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        showModal = false
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
}

#Preview {
    @Previewable @State var showModal: Bool = true
    @Previewable @State var model = CategoryModel()
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain(message: "Icono: \(model.icon)")
            
            Image(systemName: model.icon)
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        IconListModalView(model: $model, showModal: $showModal)
    }
}