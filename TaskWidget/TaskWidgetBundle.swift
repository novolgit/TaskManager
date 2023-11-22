//
//  TaskWidgetBundle.swift
//  TaskWidget
//
//  Created by Влад Новолоакэ on 22.11.2023.
//

import WidgetKit
import SwiftUI

@main
struct TaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskWidget()
        TaskWidgetLiveActivity()
    }
}
