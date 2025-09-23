//
//  DateTimeIntervalListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import SwiftUI

struct DateTimeIntervalListView: View {
    
    @StateObject var viewModel = DateTimeIntervalListViewModel()
    
    var body: some View {
        ContentContainer(addPading: false) {
            VStack {
                ListContainer {
                    SectionContainer("Intervals", isInsideList: true) {
                        ForEach(DateTimeInterval.allCases) { item in
                            VStack {
                                HStack {
                                    Image(systemName: item == viewModel.DateTimeIntervalSelected ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: FrameSize.height.selectIconInsideTextField,
                                               height: FrameSize.width.selectIconInsideTextField)
                                        .foregroundStyle(item == viewModel.DateTimeIntervalSelected ? Color.primaryBottom : Color.textFieldPlaceholder)
                                    
                                    Button {
                                        viewModel.updateDateTimeInterval(item)
                                    } label: {
                                        TextPlainLocalized(item, color: Color.textFieldForeground)
                                    }
                                }
                            }
                        }
                    }
                    
                    SectionContainer(isInsideList: true, rowColor: Color.clear) {
                        Button("Reset to default") {
                            viewModel.resetDateTimeInterval()
                        }
                        .buttonStyle(ButtonLinkStyle(color: Color.alert))
                    }
                    
                }
            }
        }
        .navigationTitle("Time interval list")
    }
}

#Preview(Previews.localeES) {
    NavigationStack {
        DateTimeIntervalListView()
            .environment(\.locale, .init(identifier: Previews.localeES))
    }
}

#Preview(Previews.localeEN) {
    DateTimeIntervalListView()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
