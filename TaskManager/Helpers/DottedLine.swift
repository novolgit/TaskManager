//
//  DottedLine.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 10.10.2023.
//

import SwiftUI

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
