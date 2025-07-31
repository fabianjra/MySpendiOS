//
//  IconListModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct IconListModalView: View {
    
    @Binding var selectedIcon: String
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationStack {
            FormContainer(addPading: false, scrollable: true, showsIndicators: false, backgroundCenter: .center) {
                
                ForEach(CategoryIcons.allCases) { icon in
                    VStack {
                        SectionContainer(icon.rawValue, isInsideList: false, textSize: .body) {
                            
                            let columns = [
                                GridItem(.adaptive(minimum: ConstantViews.gridSpacing))
                            ]
                            
                            LazyVGrid(columns: columns, alignment: .center, spacing: ConstantViews.formSpacing) {
                                ForEach(icon.list, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
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
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(ConstantRadius.cornersModal)
        .presentationDetents([.large])
    }
}

#Preview {
    @Previewable @State var showModal: Bool = true
    @Previewable @State var selectedIcon = ""
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain("Icono: \(selectedIcon)")
            
            Image(systemName: selectedIcon)
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        IconListModalView(selectedIcon: $selectedIcon, showModal: $showModal)
    }
}
