//
//  EventCardView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 10.10.2023.
//

import SwiftUI

struct EventCardView: View {
    @Environment(\.modelContext) private var modelContext
    
    let task: TaskModel
    
    let fillColor: Color
    
    let hourWidth: CGFloat
    let hourHeight: CGFloat
    let cornerRadius: CGFloat
    
    let icon: String
    
    let repeatedTask: Bool
    
    @State var animate: Bool = false
    
    let textColor: Color = Color("FTextColor")
    
    let scaleFactor: Double = 0.5
    
    var body: some View {
        //        ZStack {
        
        VStack {
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Text(getTitleText(from: task.start, to: task.end))
                        .foregroundStyle(textColor)
                        .frame(alignment: .top)
                        .font(.callout)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .minimumScaleFactor(scaleFactor)
                    
                    //                Spacer()
                    //
                    //                Image(systemName: Helper.getIconByPushType(givenPushType: task.pushType))
                    //                    .foregroundStyle(textColor)
                    //                    .symbolEffect(.bounce.up.byLayer, value: animate)
                }
                .onAppear {
                    animate = true
                }
                
                Text(task.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
                    .minimumScaleFactor(scaleFactor)
                
                if (task.descriptionText != "") {
                    Text(task.descriptionText)
                        .font(.callout)
                        .foregroundStyle(textColor)
                        .lineLimit(3)
                        .minimumScaleFactor(scaleFactor)
                }
                
                Spacer()
                
                // TODO: if isAuthed
                if repeatedTask || false {
                    HStack {
                        if repeatedTask {
                            Image(systemName: "link")
                                .font(.subheadline)
                                .foregroundStyle(textColor)
                                .lineLimit(3)
                                .minimumScaleFactor(scaleFactor)
                        }
                        
                        Spacer()
                        
                        if false {
                            ForEach(["person", "person.fill"], id: \.self) { avatar in
                                CircleImage(avatar: avatar)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: hourWidth, minHeight: 60, idealHeight: hourHeight, maxHeight: hourHeight, alignment: .bottom)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Helper.getColorByStatus(givenStatus: task.status).opacity(0.7))
            )
        }
        
            
//                .fill(LinearGradient(colors: [Color("Secondary"), Color("SecondaryLight")], startPoint: .topLeading, endPoint: .bottomTrailing))
//                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(LinearGradient(colors: [Color("SecondaryLight"), Color("Secondary")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3))
//                .shadow(color: Color.darkStart, radius: 5, x: 2.5, y: 2.5)
        //        }
                .shadow(radius: 10)
        //        .overlay(
        //            Image(systemName: icon)
        //            .offset(x: -7.5, y: -7.5)
        //            .foregroundColor(.black), alignment: .topLeading)
    }
}

#Preview {
    let hourHeight: CGFloat = 120 * 2
    let hourWidth: CGFloat = (UIScreen.main.bounds.width - 50) / 2
    
    return EventCardView(task: TaskModel.samples[0], fillColor: .blue, hourWidth: hourWidth, hourHeight: hourHeight, cornerRadius: 10, icon: "􁜯", repeatedTask: true)
}
