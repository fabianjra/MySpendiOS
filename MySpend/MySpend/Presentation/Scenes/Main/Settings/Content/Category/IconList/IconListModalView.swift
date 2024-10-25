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
                
                ForEach(Icons.allCases, id: \.self) { icon in
                    IconListView(icon: icon) { icon in
                        model.icon = icon
                        showModal = false
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
    IconListModalView(model: .constant(CategoryModel()), showModal: .constant(true))
}
