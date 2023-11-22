//
//  CustomSegmentedPickerView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 18.11.2023.
//

import SwiftUI

struct CustomSegmentedPickerView: View {
    @Binding var currentIndex: Int

    let titles: Array<String>
    
    private let colors = [Color.green, Color.blue, Color.red]

    /// - Returns the width of a picker item
    private func itemWidth(availableWidth: CGFloat) -> CGFloat {
        availableWidth / CGFloat(titles.count)
    }

    /// - Returns the x-offset for the current selection
    private func xOffsetForSelection(availableWidth: CGFloat) -> CGFloat {
        itemWidth(availableWidth: availableWidth) * CGFloat(currentIndex)
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {

                HStack {
                    ForEach(Array(titles.enumerated()), id: \.element) { i, element in
                        Text("\(element)")
                            .foregroundStyle(Color("FTextColor").opacity(currentIndex == i ? 1.0 : 0.7))
                            .font(.title3)
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                withAnimation { currentIndex = i }
                            }
                    }
                }
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color("Secondary"))
                        .frame(
                            width: itemWidth(availableWidth: proxy.size.width),
                            height: 2
                        )
                        .offset(x: xOffsetForSelection(availableWidth: proxy.size.width))
                    
                    Rectangle()
                        .foregroundColor(Color("Secondary").opacity(0.3))
                        .frame(
                            width: proxy.size.width,
                            height: 2
                        )
                }

            }
        }
        .frame(height: 40)
        .padding(.horizontal)
        .padding(.top)
    }
}

#Preview {
    CustomSegmentedPickerView(currentIndex: .constant(0), titles: ["first", "second"])
}
